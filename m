Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1JNTBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:01:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42051 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab1JNTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAEbykaWbtBvHQMQjRt7NDngy1oz=dBAZ3ii79XOJKvF5-fPaew@mail.gmail.com>
References: <CAEbykaX=HWMJmTB0VCFkfW2v2G9=FcnFZBFwrYk8bFTT_FrD-Q@mail.gmail.com>
	<1318452651.14236.9.camel@twins>
	<CAEbykaWbtBvHQMQjRt7NDngy1oz=dBAZ3ii79XOJKvF5-fPaew@mail.gmail.com>
Date: Fri, 14 Oct 2011 22:01:11 +0300
Message-ID: <CAEbykaUZuyBrZsLn0pxBA2wiuOO=nt6GvZ7WuMbT+jwOArBmKw@mail.gmail.com>
Subject: Re: sig->cputimer.lock/rq->lock lockdep report
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today there were no freezes in nine hours with the patch applied.

Ari
