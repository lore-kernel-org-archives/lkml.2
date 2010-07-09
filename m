Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0GIXY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:24:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54432 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0GIXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=U/VsA9d9rIjoi1gR15ugRmwLOt+jwilEtA+NOMOrSdwSVqZZJQjLkVEGGXeOrEySDg
         2JIuJZVMKnhCMHlrwLtCb9aSnYe5jGwBXayg+xSI6mbKTLwgA98X4cCwJVYn8ng+zvLS
         kjnrraRSFDoNpyS3lR7et2+3x5MoJHkfd91uc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
Date: Fri, 9 Jul 2010 16:24:47 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4+; KDE/4.4.4; x86_64; ; )
Cc: werner@sys-linux.yi.org, linux-kernel@vger.kernel.org
References: <1278618295.14439@sys-linux.yi.org> <201007081622.04777.dmitry.torokhov@gmail.com> <4C37AA80.90203@zytor.com>
In-Reply-To: <4C37AA80.90203@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091624.47920.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010 04:02:24 pm H. Peter Anvin wrote:
> On 07/08/2010 04:22 PM, Dmitry Torokhov wrote:
> > On Thursday, July 08, 2010 12:44:55 pm werner@sys-linux.yi.org wrote:
> >> For produce dmesg files, I rebooted with 2.6.26.2 , 2.6.35-rc4-git2 ,
> >> 2.6.35-rc1 ; only the second case had the problem that the PS2 keyboard
> >> and mouse dont work.
> >> 
> >> Below the dmesg files.
> >> 
> >> Added is also the config file for all 3 kernels, incl. 2.6.35-rc4-git2
> >> (unchanged since -rc3-git1).  Its this whats now in /boot , so that it
> >> was used during all these 3 boots (although the original configuration
> >> of the two other kernels was different)
> > 
> > OK, here is your problem:
> >> CONFIG_X86_MRST=y
> > 
> > Disable it for now (you do not have Moorestown platfrom) and PS/2
> > subsystem should be back.
> 
> The recent patchset from Feng should take care of this, right?

Right, but Werner is not on Moorestown anyway so disabling X86_MRST should
be acceptable workaround for him.

-- 
Dmitry
