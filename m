Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1ATBWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:22:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1ATBWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:22:19 -0500
Date: Thu, 20 Jan 2011 02:21:58 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: werner <w.landgraf@ru.ru>, Borislav Petkov <bp@amd64.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110120012158.GT9506@random.random>
References: <web-442414153@zbackend1.aha.ru>
 <20110119155954.GA2272@kryptos.osrc.amd.com>
 <20110119214523.GF2232@cmpxchg.org>
 <20110120000147.GR9506@random.random>
 <20110120011026.GJ2232@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120011026.GJ2232@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 02:10:26AM +0100, Johannes Weiner wrote:
> Actually, I sent it half an hour before you ;-) But good to see that
> it fixes the problem.

I see, if I read your email before Ilya's PM it'd been
easier. Let's consider my patch an aked-by then ;).
