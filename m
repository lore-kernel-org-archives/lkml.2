Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab0HSAvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:51:00 -0400
Received: from ozlabs.org ([203.10.76.45]:53948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0HSAu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:50:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mahatma@eu.by
Subject: Re: More modaliases + patchtool
Date: Thu, 19 Aug 2010 10:20:52 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C6BE292.3060307@bspu.unibel.by>
In-Reply-To: <4C6BE292.3060307@bspu.unibel.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191020.52861.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 11:09:30 pm Dzianis Kahanovich wrote:
> First I post into linux-modules@vger.kernel.org, but Jon Masters suggest to
> send this to you. There are some more against maillist:
> 
> Some of modules have no MODULE_DEVICE_TABLE(...) and do not export hardware
> ("pnp") aliases, but have all required data to do this. I found it after
> ioatdma module (currently fixed in tree). This information may be useful to
> hardware/modules detection.

> [+] Also known problem: 2 modules (in 2.6.36 state) - scx200_acb.c & pch_dma.c
> - have not NULL-terminated pci_device_id record. This is "easy" to fix, but
> currently I excluding this modules in script. For you I attaching patch for
> this modules and related script ("modulesfix4patched") too.

Thanks, can you format that patch with a simple description and a
Signed-off-by: line and I'll apply it (see Documentation/SubmittingPatches,
especially part 12).

Then can you send me another patch with the results of your script.

Finally, I suggest that your script should only fix files when passed --fix,
and create a config option to run it (without --fix) under in
lib/Kconfig.debug.

Thanks!
Rusty.
