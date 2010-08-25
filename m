Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0HYTAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:00:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59794 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0HYTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lWFMArzj6PL7AyRzwmbl1b3DlMB3iPElmBuboXmk9sZNg08mjriIVGcoZ7ZBinmAWT
         3hdjRJyvbUX7Cz5bmQ3C8K9QpCapP8lRKHmzpzXzppTjOU3YvK04qsSyvgTfFfqnDwu0
         mLZ+RmPfIKUmGx3jpoLUbg4z+gy5VhV5ocvy4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: possible esata regression in 2.6.35
Date: Wed, 25 Aug 2010 21:00:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C702070.5020809@jungers.net>
In-Reply-To: <4C702070.5020809@jungers.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008252100.38534.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 21 sierpnia 2010 o 20:52:32 Nicolas Jungers wrote:
> My arm box doesn't succeed to use my esata port multiplier (addonics
> sil3726 based).  It was working well with 2.6.34.1 and 2.6.34.4 but not
> with both 2.6.35.2 and 2.6.35.3.  I haven't test other kernels.
> 
> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
> example the following config
> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
> 
> The symptoms are in the console a loop on the esata links.  Here is the
> start of it:
> 
> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
> ata2: SError: { PHYRdyChg DevExch }
> ata2: hard resetting link
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.03: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.03: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.00: failed to recover link after 3 tries, disabling
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17071
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
