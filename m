Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab2JOJO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:14:59 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42568 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2JOJO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:14:58 -0400
Message-ID: <507BD3FC.1020703@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 14:44:36 +0530
From: preeti <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: peterz@infradead.org, svaidy@linux.vnet.ibm.com, pjt@google.com
Subject: Re: [RFC PATCH 0/2] sched: Load Balancing using Per-entity-Load-tracking
References: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
In-Reply-To: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101509-5490-0000-0000-00000249E09D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The past few weeks must have been very tight due to the merge
window phase.Looks like it got through well :)

I request you to comment on this patchset.Primarily because it forces us
to look into the below scenario:

Highly loaded sched groups does not mean too many tasks and less loaded
sched groups does not mean too few tasks.

Thank you

Regards
Preeti

