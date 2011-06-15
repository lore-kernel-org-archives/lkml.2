Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1FOTz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:55:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35874 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1FOTzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xu+4pxJrZ1gAf0HXowDE6t7WRV7wN30JbSOwmFmr3zRjlk/KM7Ka7RSYXCVfh2LGVv
         s8w43rjfSnAHVd750l+xAOWqQy3fn9Gf7AdRaB7A0B4EatB+2PLoxx+EtYDYuSeYrsKy
         XIxrS+sm5uZM0+j8I14xsRtM3Jey2lrto8oCI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Wed, 15 Jun 2011 21:55:47 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1; KDE/4.4.5; i686; ; )
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
In-Reply-To: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106152155.48167.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 9 czerwca 2011 o 22:15:05 Martijn Uffing wrote:
> Ave People
> 
> 
> I've got an oops with 3.0-rc1. (The same Oops also occurs with 3.0-rc2 and
> the git snapshot of today linux-2.6-06e8684.)
> The Oops occurs at boot time while the boot scripts try to automount a
> samba share.
> 
> Last (tested)  working kernel	:	2.6.39
> First (tested) oopsing kernel	:	3.0-rc1

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=37542
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
