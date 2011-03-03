Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab1CCUC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:02:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1CCUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=o15QbcC67z2fVszZ+hK3Y8OmWVgiuct/h2Uaa1fCAeP6HlsODVbTUIkPgn4Hk9hcay
         FD0PG0IAACzZ6LyunIDuEqMjJhSWAnh4i/rg4uNoreTQnBgVixcWuj3KqRzPyd+utTNB
         5AW13Kz/p/EztrMTFMUPdYIUSiS7OKJvMZ49A=
Date: Thu, 3 Mar 2011 21:01:52 +0100
From: Paolo Ornati <ornati@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [2.6.38-rc6] G965: i915 Hangcheck timer elapsed... GPU hung
 (not reproducible)
Message-ID: <20110303210152.5750c239@gmail.com>
In-Reply-To: <20110303004326.GA18486@elliptictech.com>
References: <20110227101041.6b864352@gmail.com>
	<20110302155648.421f0292.akpm@linux-foundation.org>
	<20110303004326.GA18486@elliptictech.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011 19:43:26 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> So you might want to try again with the latest git xf86-video-intel and
> see if it still happens.

xf86-video-intel bug or not the kernel should be able to reset the GPU
I think... (I'm using KMS).

Anyway I'm using 2.6.38-rcX on this PC for a month, and it happened
only once. This is the complete list of 2.6.38 based kernel I've used an
when (login time):

Sun Jan 30 09:00:04 CET 2011 -- Linux tux 2.6.38-rc2-00274-g1f0324c 
Sun Jan 30 15:52:14 CET 2011 -- Linux tux 2.6.38-rc2-00274-g1f0324c 
Mon Jan 31 20:01:29 CET 2011 -- Linux tux 2.6.38-rc2-00274-g1f0324c 
Tue Feb  1 19:31:05 CET 2011 -- Linux tux 2.6.38-rc2-00274-g1f0324c 
Wed Feb  2 19:39:28 CET 2011 -- Linux tux 2.6.38-rc3 
Thu Feb  3 19:22:14 CET 2011 -- Linux tux 2.6.38-rc3 
Fri Feb  4 20:14:07 CET 2011 -- Linux tux 2.6.38-rc3 
Sat Feb  5 08:09:57 CET 2011 -- Linux tux 2.6.38-rc3 
Sun Feb  6 09:28:15 CET 2011 -- Linux tux 2.6.38-rc3 
Sun Feb  6 13:09:55 CET 2011 -- Linux tux 2.6.38-rc3 
Mon Feb  7 19:31:43 CET 2011 -- Linux tux 2.6.38-rc3 
Tue Feb  8 19:56:27 CET 2011 -- Linux tux 2.6.38-rc3 
Wed Feb  9 20:09:37 CET 2011 -- Linux tux 2.6.38-rc4 
Fri Feb 11 20:01:20 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 09:16:32 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 12:28:23 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 14:39:15 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 15:05:29 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 15:20:37 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 15:23:49 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 12 20:44:18 CET 2011 -- Linux tux 2.6.38-rc4 
Sun Feb 13 08:40:09 CET 2011 -- Linux tux 2.6.38-rc4 
Sun Feb 13 13:11:28 CET 2011 -- Linux tux 2.6.38-rc4 
Mon Feb 14 20:20:12 CET 2011 -- Linux tux 2.6.38-rc4 
Tue Feb 15 20:28:22 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 19 08:55:51 CET 2011 -- Linux tux 2.6.38-rc4 
Sat Feb 19 09:56:02 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Sat Feb 19 13:50:37 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Sat Feb 19 18:05:28 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Sat Feb 19 20:12:05 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Sun Feb 20 08:57:19 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Sun Feb 20 18:05:43 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Mon Feb 21 20:22:51 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Tue Feb 22 20:02:13 CET 2011 -- Linux tux 2.6.38-rc5-00100-g0cc9d52 
Wed Feb 23 20:06:45 CET 2011 -- Linux tux 2.6.38-rc6-00020-gd8204a3 
Thu Feb 24 20:15:23 CET 2011 -- Linux tux 2.6.38-rc6-00020-gd8204a3 
Fri Feb 25 20:04:37 CET 2011 -- Linux tux 2.6.38-rc6-00020-gd8204a3 
Sat Feb 26 09:18:44 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Sat Feb 26 19:45:28 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Sun Feb 27 09:12:54 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 <--- GPU hung ;)
Sun Feb 27 09:32:17 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Sun Feb 27 15:32:46 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Sun Feb 27 17:38:17 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Mon Feb 28 21:00:49 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Tue Mar  1 20:25:01 CET 2011 -- Linux tux 2.6.38-rc6-00113-g4662db4 
Thu Mar  3 20:27:57 CET 2011 -- Linux tux 2.6.38-rc6-00212-g3e1f235

I'll see if it happens again...

-- 
	Paolo Ornati
	Linux 2.6.38-rc6-00212-g3e1f235 on x86_64
