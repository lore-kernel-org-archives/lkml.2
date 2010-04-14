Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0DNPjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:39:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52583 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0DNPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=QsKO3l62b8zP+wNJ4HuepL3eEx/y2IwRJHJJyFrNMK4zBMR1CkNpp436W+xRoRZdqd
         RcoM04iHs0tIhoWWgHiribXlIj9Mx09j/C6CoEWIviAB0wP4qS5AFiHaWVDE7nlkxtec
         mCZNpqlptETNlYm/C+cOdpOErCyKzYaBc5NJM=
Message-ID: <4BC5E19C.8060509@roadrunner.com>
Date: Wed, 14 Apr 2010 11:39:08 -0400
From: Frank Griffin <ftg@roadrunner.com>
Reply-To: ftg@roadrunner.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090903 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net>	<4BC5AD08.8040606@tremplin-utc.net> <s5hy6gqxiev.wl%tiwai@suse.de> <4BC5D2F4.4010500@tremplin-utc.net>
In-Reply-To: <4BC5D2F4.4010500@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel wrote:
> Frank,
> Could you check that for you too adding "position_fix=1" fixes the problem?
>
> To do so, edit /etc/modprobe.conf and add this line at end:
> options snd-hda-intel position_fix=1
>
> You need to reboot for this to be taken into account.
>
>   
That fixes not only the playback speed, but also the fact that the 
failing system had no sound since the problem started (the acceleration 
was noticed in movie playback).

Thanks !
