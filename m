Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2ARJd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:33:57 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:46866 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2ARJdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:33:55 -0500
Message-ID: <4F1691FF.5010703@de.ibm.com>
Date: Wed, 18 Jan 2012 10:33:51 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/s390: fix compile error in sched/core.c
References: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com> <1326272868.2442.122.camel@twins>
In-Reply-To: <1326272868.2442.122.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011809-1948-0000-0000-000000AB2D0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/12 10:07, Peter Zijlstra wrote:

> Weird, I would have expected -next to pick this up.. Anyway, no
> objection although do we really need that extra #ifdef ?

Ping.
Do you want me to resubmit without ifdefs?

