Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0JUR7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:59:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37795 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0JUR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EkE9539FOH7R8SbhnFJEzxs4DDN0PEDFFPJZ8yQcm6pJgO6QAFLR3i7RovEC4fl7x4
         sm0M4C0bLQj4fZHrR66nnhblFSGNflYjqSsM9P7tKwaK5C0+IgtmGHo7+Qq1o8ovR8gS
         jWnn7B/EXPipIqmSrp9+QGSyPvcYS+AF0kw6I=
Message-ID: <4CC07F7F.5050608@gmail.com>
Date: Thu, 21 Oct 2010 19:59:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        clemens@ladisch.de, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CBFEE94.7020103@gmail.com> <s5hlj5sc7do.wl%tiwai@suse.de>            <4CBFF25C.2080908@gmail.com> <13987.1287674569@localhost>
In-Reply-To: <13987.1287674569@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 05:22 PM, Valdis.Kletnieks@vt.edu wrote:
> Didn't we have some flustercluck a while back that gave pulseaudio
> similar indigestion?  Oh, here it is, it was an fsnotify botch, of all things.
> 
> commit 2069601b3f0ea38170d4b509b89f3ca0a373bdc1
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Aug 12 14:23:04 2010 -0700
> 
>     Revert "fsnotify: store struct file not struct path"

Yes, I was attacked by that in the past, but I doubt that's it now.
Pulse was unable to start -- the second open of the snd device failed
which doesn't seem to happen now.

Going to switch hda intel from Y to M and play with that (revert the
patches at first).

regards,
-- 
js
