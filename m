Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1ESMn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:43:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39232 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932472Ab1ESMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:43:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19v9NYcpY1vLEpYCo01pWbrHn78nW/AvZng+bUFhn
	OClBSrS5/xRgmO
Subject: Re: [RFC][PATCH] sched: Fix min_vruntime calculation in
 dequeue_entity
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Dima Zavin <dima@android.com>
In-Reply-To: <1305806316.2466.7221.camel@twins>
References: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
	 <1305806316.2466.7221.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 14:43:23 +0200
Message-ID: <1305809003.5058.53.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 13:58 +0200, Peter Zijlstra wrote:
> On Tue, 2011-05-17 at 16:21 -0700, John Stultz wrote:
> > While Dima never replied publicly, I bugged him a few weeks ago
> > and he said that this fix should address his original issue.
> 
> Should or does? :-)
> 
> I was really hoping for a tested-by tag..

Recalls-having-tested-once-upon-a-time-by: Mike Galbraith <efault@gmx.de> :)

