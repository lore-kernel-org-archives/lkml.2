Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2HFOig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:38:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57467 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932082Ab2HFOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:38:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fl/YjnDYfH+Z4ZTmrDwCIOIRpORmSImpKCr5GSQ
	ishOYXvi6VNq2D
Message-ID: <1344263912.6853.14.camel@marge.simpson.net>
Subject: Re: unfair scheduling with tbb application observed, could it be a
 kernel issue?
From: Mike Galbraith <efault@gmx.de>
To: Pedro Larroy <pedro.larroy.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Aug 2012 16:38:32 +0200
In-Reply-To: <CAC_CU1iP0y9pVPPWVuER3kZbFGbBwS6Q2w1mJ6Ke6VNLqJOgbA@mail.gmail.com>
References: <CAC_CU1hzuSAeHG7-5g5kOa=MMh3KnJZNwWr+ySkJQyxixck4WA@mail.gmail.com>
	 <1344263139.6853.10.camel@marge.simpson.net>
	 <CAC_CU1iP0y9pVPPWVuER3kZbFGbBwS6Q2w1mJ6Ke6VNLqJOgbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 16:28 +0200, Pedro Larroy wrote: 
> I didn't enable cgroups explicitly, and don't have userspace tools for
> that installed.

You don't userspace tools.  cat /proc/<pid>/cgroup will show the group.

-Mike

