Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0J3TIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:08:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59898 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0J3TIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:08:51 -0400
Date: Sat, 30 Oct 2010 15:06:07 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Aidar Kultayev <the.aidar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101030190607.GB2918@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Aidar Kultayev <the.aidar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Ted Ts'o <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
 <20101028090002.GA12446@elte.hu>
 <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
 <20101028133036.GA30565@elte.hu>
 <20101028170132.GY27796@think>
 <AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
 <20101029145212.GA21205@thunk.org>
 <AANLkTim-A7DLOOw4myQU3Lfip+ZEE32F2Ap_PJXuxG6G@mail.gmail.com>
 <20101030091440.GA15276@elte.hu>
 <AANLkTim-hgA3-9T_N5k53Sga5LMazMQPmmQZzQsoQvRY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim-hgA3-9T_N5k53Sga5LMazMQPmmQZzQsoQvRY@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 07:02:35PM +0600, Aidar Kultayev wrote:
> Hi,
> 
> here is what I have :
> 
> .ext4 mounted with data=ordered
> .-tip tree ( uname -a gives : Linux pussy 2.6.36-tip+ )
> 
> here is the latencytop & powertop & top screenshot:
> 
> http://picasaweb.google.com/lh/photo/bMTgbVDoojwUeXtVdyvIKw?feat=directlink

It's actually better, fsync is missing anyway.  Please try ext4
data=writeback.

-chris
