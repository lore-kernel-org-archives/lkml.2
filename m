Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2HFPO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:14:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51225 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932185Ab2HFPOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:14:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bk8c3b8ubv2/W3bcRG+dv1At1kV5lY862TZNDyS
	ct7Fj8DpAu09CB
Message-ID: <1344266062.6853.26.camel@marge.simpson.net>
Subject: Re: unfair scheduling with tbb application observed, could it be a
 kernel issue?
From: Mike Galbraith <efault@gmx.de>
To: Pedro Larroy <pedro.larroy.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Aug 2012 17:14:22 +0200
In-Reply-To: <1344264419.6853.19.camel@marge.simpson.net>
References: <CAC_CU1hzuSAeHG7-5g5kOa=MMh3KnJZNwWr+ySkJQyxixck4WA@mail.gmail.com>
	 <1344263139.6853.10.camel@marge.simpson.net>
	 <CAC_CU1iP0y9pVPPWVuER3kZbFGbBwS6Q2w1mJ6Ke6VNLqJOgbA@mail.gmail.com>
	 <1344263912.6853.14.camel@marge.simpson.net>
	 <1344264419.6853.19.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, with the sched_debug info you sent offline, booting with noautogroup
appended to the kernel command line should fix it up for you.  You've
got autogroup enabled, which creates automagic per session task groups.

-Mike  

