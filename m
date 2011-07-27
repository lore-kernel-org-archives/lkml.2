Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1G0IIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:08:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34639 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1G0IIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:08:01 -0400
Date: Wed, 27 Jul 2011 10:07:56 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 13/13] memblock, x86: Replace
 memblock_x86_reserve/free_range() with generic ones
Message-ID: <20110727080756.GV2622@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
 <1310462166-31469-14-git-send-email-tj@kernel.org>
 <CAE9FiQU3+ceB+uDY6q2WyBvaTsJr-v9sRF7DDr_omNMf49o3Kg@mail.gmail.com>
 <CAOS58YOYOMNmLTn=MLdObwfUPLb-xOr1Xw7aLoEWcDb8esAX4A@mail.gmail.com>
 <CAE9FiQX5F2H_SaPTO0CxP9sAzmg0JSchonf1KXONOjkrB0rP+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX5F2H_SaPTO0CxP9sAzmg0JSchonf1KXONOjkrB0rP+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Tue, Jul 26, 2011 at 05:59:13PM -0700, Yinghai Lu wrote:
> yes, with bootmem wrap stage, the print out are all the same.
> 
> will have
> __alloc_memory_core_early+0x63
> everywhere.
> 
> add name print out for comparing, name could give some hint.

The better solution would be making __alloc_memory_core_early() pass
in its caller and print it out.  I don't think requiring pretty name
just for debugging is a good or scalable idea.  There's no reason to
bother API users with it.

Thanks.

-- 
tejun
