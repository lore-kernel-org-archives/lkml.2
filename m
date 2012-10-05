Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2JENzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:55:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36061 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783Ab2JENzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:55:38 -0400
Message-ID: <506EE6D5.4010603@sgi.com>
Date: Fri, 5 Oct 2012 08:55:33 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>  <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>  <506DB30F.2000704@sgi.com> <1349368662.2008.20.camel@joe-AO722>
In-Reply-To: <1349368662.2008.20.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 11:37 AM, Joe Perches wrote:
> On Thu, 2012-10-04 at 11:02 -0500, Nathan Zimmer wrote:
>> At many of our customer sites the log level is set to KERN_DEBUG. It
>> helps avoid reboots due to operator impatience.  Machines this large
>> take significantly longer then typical to boot and seeing the extra
>> messages reassures them that the kernel isn't hung.
> That argues for adding some KERN_INFO "still booting" messages
> not logging unnecessary KERN_DEBUG messages.
>
>
Actually I would think that argues for reducing boot times on these 
large systems.
