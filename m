Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0ESBGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab0ESBGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:06:35 -0400
Date: Wed, 19 May 2010 03:05:58 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v2 5/5] extend KSM refcounts to the anon_vma root
Message-ID: <20100519010558.GK25903@random.random>
References: <20100512134111.467fb6c2@annuminas.surriel.com>
 <20100512210706.GQ24989@csn.ul.ie>
 <4BEB18FE.1090808@redhat.com>
 <20100513112603.GB27949@csn.ul.ie>
 <4BEBFA82.2000301@redhat.com>
 <20100513132436.GC27949@csn.ul.ie>
 <20100513103446.7eecd5b9@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513103446.7eecd5b9@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:34:46AM -0400, Rik van Riel wrote:
> +		int empty list_empty(&anon_vma->head);

Adding "=" and hope it all works.
