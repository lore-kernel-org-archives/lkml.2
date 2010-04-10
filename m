Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0DJOAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:00:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0DJN77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 09:59:59 -0400
Subject: Re: [PATCH] Add "nested" field to event of lock_release
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1270896100-7935-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1270896100-7935-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Apr 2010 15:59:46 +0200
Message-ID: <1270907986.4222.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 19:41 +0900, Hitoshi Mitake wrote:
> State machine of perf lock requires "nested" field of lock_release(),
> so this patch adds it to event.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

The nested flag only indicates if it could be nested, not if it was
actually nested. So no, this doesn't make any sense at all.

(in fact, pretty much every lock_release out there has nested=1)

