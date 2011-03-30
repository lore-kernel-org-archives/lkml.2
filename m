Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1C3UJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:09:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40632 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab1C3UJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:09:55 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Roman Zippel <zippel@linux-m68k.org>,
        linux-m68k@vger.kernel.org,
        Michael Schmitz <schmitzmic@googlemail.com>
Subject: Re: [PATCH] m68k: fix find_next bitops
References: <1301050810-11329-1-git-send-email-akinobu.mita@gmail.com>
	<AANLkTikKA2MY6nf+LLyJbNQffX=qYY3eZdpNmwVQc21u@mail.gmail.com>
X-Yow: Maybe we could paint GOLDIE HAWN a rich PRUSSIAN BLUE--
Date: Wed, 30 Mar 2011 22:09:52 +0200
In-Reply-To: <AANLkTikKA2MY6nf+LLyJbNQffX=qYY3eZdpNmwVQc21u@mail.gmail.com>
	(Geert Uytterhoeven's message of "Wed, 30 Mar 2011 20:02:50 +0200")
Message-ID: <m2sju4jrov.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Andreas, do you think it's worth keeping (and fixing) the m68k "optimized"
> versions?

Should be easy to add the required offset >= size checks.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
