Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1GAAdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:33:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58783 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1GAAdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:33:13 -0400
Message-ID: <4E0D15C2.8000209@zytor.com>
Date: Thu, 30 Jun 2011 17:33:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Chubb <peter.chubb@nicta.com.au>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>	<20110622194324.GD8861@srcf.ucam.org>	<w4sjr1v323.wl%peter@chubb.wattle.id.au>	<4E0CC06E.7040204@zytor.com>	<w4d3huc3va.wl%peter@chubb.wattle.id.au>	<20110630235802.GA18584@srcf.ucam.org>	<4E0D1239.70205@zytor.com>	<20110701002221.GA19015@srcf.ucam.org> <w4iprmkfie.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w4iprmkfie.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 05:31 PM, Peter Chubb wrote:
> 
>  Matthew> I guess I'm going to have to go back and retest the XP
>  Matthew> behaviour. I'd expect this machine to be using the ACPI
>  Matthew> vector there too.
> 
> This machine was only ever shipped with Linux (Linpus) on it, AFAIK.
> 

OK, so the old Linux behavior was the only that ever got exercised.
That makes sense.

	-hpa
