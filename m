Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1FMSpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:45:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47374 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1FMSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xpLxw3Cyj4AQyKJE6qqcBWxuyKyRuHzuDbK3Lffxu/jN/335vy2b7kwfGcopyoep7i
         RCo0DOnMkz728qvM/6NkvyIaanOUoomlONEY6m+jwCT0YSrVCPP6nhoivregjB/6Ltjo
         g/2POm8RXSYvaqVuluP8nAxybgwRp3wN+Rb60=
Message-ID: <4DF65ACB.6020402@gmail.com>
Date: Mon, 13 Jun 2011 20:45:31 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <20110613164712.GA23343@srcf.ucam.org> <4DF64E6A.70700@gmail.com> <20110613180006.GA24902@srcf.ucam.org> <4DF65372.7090307@gmail.com> <20110613181750.GA25372@srcf.ucam.org> <4DF655B5.8040903@gmail.com> <20110613183301.GA25644@srcf.ucam.org>
In-Reply-To: <20110613183301.GA25644@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try what happens with my patch + moving insert_resource for kernel before efi_init.

Op 13-06-11 20:33, Matthew Garrett schreef:
> Ok, that's odd. These are 0x01800000-0x01900000, which should lie inside 
> the kernel data range (01580279-01aa4cff : Kernel data). We should be 
> skipping that region. How are we touching that reange at all? Can you 
> add a printk to reserve_boot_services to see what it actually ends up 
> reserving?
~Maarten
