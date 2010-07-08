Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab0GHXWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:22:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51460 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0GHXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WniR+yyXWGe+pbkoP31JPF4T4enY83bIMDEMY3iZVDOvwCscFgVVrMeCfYAueUVh3R
         X5pSGhIOrRN1paVeL0loZFb+VZtzQcrmZsIzkg2eZUJxYxqGvkuvIc3GaJtA2+OjLw03
         3BMpSop3MNMCVv/hdReDTyXp5EfGmzwpLKRVg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: werner@sys-linux.yi.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
Date: Thu, 8 Jul 2010 16:22:03 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1278618295.14439@sys-linux.yi.org>
In-Reply-To: <1278618295.14439@sys-linux.yi.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081622.04777.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 08, 2010 12:44:55 pm werner@sys-linux.yi.org wrote:
> For produce dmesg files, I rebooted with 2.6.26.2 , 2.6.35-rc4-git2 ,
> 2.6.35-rc1 ; only the second case had the problem that the PS2 keyboard
> and mouse dont work.
> 
> Below the dmesg files.
> 
> Added is also the config file for all 3 kernels, incl. 2.6.35-rc4-git2
> (unchanged since -rc3-git1).  Its this whats now in /boot , so that it was
> used during all these 3 boots (although the original configuration of the
> two other kernels was different)

OK, here is your problem:

> CONFIG_X86_MRST=y

Disable it for now (you do not have Moorestown platfrom) and PS/2
subsystem should be back.

-- 
Dmitry
