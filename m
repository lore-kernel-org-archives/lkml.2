Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0KQFmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:42:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48131 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0KQFmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:42:19 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
References: <20101116104600.GA24015@suse.de> <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 17 Nov 2010 00:41:58 -0500
Message-ID: <AANLkTinykkc8=zCvAyz4_Qj=kU0Ogdbnur6G8fpe63uU@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: Marcus Meissner <meissner@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@osdl.org, hpa@zytor.com, mingo@elte.hu, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops... I apparently can't count to 3... (at least not correctly anyways) :-D.

On Wed, Nov 17, 2010 at 00:40, Kyle Moffett <kyle@moffetthome.net> wrote:
>  (1) For 99%+ of all the computers out there you can get a 90%+
[...]
>  (2) Most of the arguments about introducing "uncertainty" into the
[...]
>  (2) By just flat out changing the permissions on this file you are
[...]
>  (3) If you are really interested in locking down a system to this

Cheers,
Kyle Moffett
