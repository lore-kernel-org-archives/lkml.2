Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0LaICS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 03:02:18 -0500
Received: from mail.agmk.net ([91.192.224.71]:33864 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab0LaICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 03:02:17 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Dec 2010 09:02:15 +0100
From: =?UTF-8?Q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Neil Brown <neilb@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
In-Reply-To: <20101231100012.3e6e3c1f@notabene.brown>
References: <201012301608.40859.pluto@agmk.net>
 <1293723098.25156.2.camel@jaguar> <201012302039.33305.pluto@agmk.net>
 <20101231100012.3e6e3c1f@notabene.brown>
Message-ID: <dfd5ffc181315d383c5d069c343b76af@agmk.net>
User-Agent: RoundCube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Fri, 31 Dec 2010 10:00:12 +1100, Neil Brown <neilb@suse.de> wrote:
> Please report exactly which kernel you are running (git hash of head) 
> and in
> particular whether
>    commit  589a594be1fb8815b3f18e517be696c48664f728
>
> is present?

 i'm testing the pure 2.6.37-rc8 which afaics contains mentioned merge:

 3d0b608 589a594
 Author: Linus Torvalds <torvalds@linux-foundation.org>
 Date:   Tue Dec 14 18:49:40 2010 -0800
     Merge branch 'for-linus' of git://neil.brown.name/md

