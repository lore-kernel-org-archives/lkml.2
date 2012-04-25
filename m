Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2DYPDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:03:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:37615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2DYPDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:03:01 -0400
Message-ID: <1335366172.28150.268.camel@twins>
Subject: Re: [PATCH 1/2] math128: Introduce {mult,add,cmp}_u128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jay Foad <jay.foad@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 17:02:52 +0200
In-Reply-To: <CANd1uZ=btyt8q5vbhFjh06bij2xaqGxMLjHf10ORk-XQq-gSxQ@mail.gmail.com>
References: <CANd1uZ=btyt8q5vbhFjh06bij2xaqGxMLjHf10ORk-XQq-gSxQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 15:29 +0100, Jay Foad wrote:
> > +             res.hi |= x.lo >> (64 - n);
> 
> This is undefined when n == 0.
> 
> 
Thanks, added a !n test.
