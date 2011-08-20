Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1HTWWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 18:22:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57720 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1HTWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 18:22:07 -0400
Message-ID: <4E50338C.5000504@landley.net>
Date: Sat, 20 Aug 2011 17:22:04 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: LKML <linux-kernel@vger.kernel.org>, gerg@uclinux.org
Subject: Re: m68k with mmu doesn't compile after 66d857b08b8c3ed
References: <4E5008A1.8070105@landley.net> <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com>
In-Reply-To: <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2011 02:46 PM, Geert Uytterhoeven wrote:
> Hi Rob,
> 
> You're really confusing me.

Sorry, I was the one confused.  My .config got screwed up moving to 3.0
so I was accidentally building most of an "allnoconfig".  I tried again
with atari_defconfig and it built, I'll reassemble my config from there.

My bad, sorry for the noise,

Rob
