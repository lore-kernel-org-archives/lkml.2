Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1GAASM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:18:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1GAASL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:18:11 -0400
Message-ID: <4E0D1239.70205@zytor.com>
Date: Thu, 30 Jun 2011 17:18:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au> <20110622194324.GD8861@srcf.ucam.org> <w4sjr1v323.wl%peter@chubb.wattle.id.au> <4E0CC06E.7040204@zytor.com> <w4d3huc3va.wl%peter@chubb.wattle.id.au> <20110630235802.GA18584@srcf.ucam.org>
In-Reply-To: <20110630235802.GA18584@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 04:58 PM, Matthew Garrett wrote:
> On Fri, Jul 01, 2011 at 09:10:33AM +1000, Peter Chubb wrote:
> 
>> t, p and a all result in a machine hang with the power light on, the
>> backlight off, and no apparent activity anywhere.
> 
> Having PCI reboot be broken does make me wonder whether there's 
> something about the hardware state that confuses it.
> 

It might be a RESET versus INIT difference... if the "PCI reboot" (which
is what "ACPI reboot") points to, it might end up pulling INIT, whereas
the keyboard controller pulls RESET.

RESET would forcibly initialize the hardware state of the machine,
obviously...

	-hpa

