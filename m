Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2DSIRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:17:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35619 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DSIRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:17:01 -0400
X-AuditID: cbfee61b-b7cb4ae000000d81-4d-4f8fc9ef5aab
From: l.stelmach@samsung.com (=?utf-8?Q?=C5=81ukasz?= Stelmach)
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] perf stat: fix output selection introduced in 56f3bae7
References: <1334823205-15754-1-git-send-email-l.stelmach@samsung.com>
Date: Thu, 19 Apr 2012 10:16:44 +0200
In-reply-to: <1334823205-15754-1-git-send-email-l.stelmach@samsung.com>
Message-id: <87zka8uoer.fsf@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Łukasz Stelmach <l.stelmach@samsung.com> writes:

> 56f3bae7 makes perf require either --output or --log-fd. Without them
> perf exited after erroneously trying to open stdout (file descriptor 0
> by default) for writing.

It should be "stdin" not "stdout".
-- 
Łukasz Stelmach
Software engineer
Samsung Poland R&D Center

ul. Polna 11, 00-633 Warszawa
http://www.rd.samsung.pl
