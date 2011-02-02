Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1BBCgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:36:12 -0500
Received: from science.horizon.com ([71.41.210.146]:51325 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751835Ab1BBCgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:36:12 -0500
Date: 1 Feb 2011 21:36:10 -0500
Message-ID: <20110202023610.3799.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gorcunov@gmail.com, linux@horizon.com
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Cc: a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com, mingo@elte.hu
In-Reply-To: <4D484853.9020409@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  But if you have a will or would like to help debug the problem -- mind to
> try the patch below? Note the patch is ugly at moment and must *not* be
> running on non-P4 system (and I only compile-tested it so no guarantees
> at all, and I've CC'ed a couple of people as well)

Promising...  After 32 minute of uptime, no NMI complaints so far.

I'll let it run overnight and see what happens.

Thank you very much!
