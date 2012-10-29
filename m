Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2J2KXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:23:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab2J2KXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:23:41 -0400
Message-ID: <1351506201.24721.7.camel@twins>
Subject: Re: [PATCH 01/33] perf, x86: Add PEBSv2 record support
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, eranian@google.com,
        mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Date: Mon, 29 Oct 2012 11:23:21 +0100
In-Reply-To: <874nld8ubf.fsf@sejong.aot.lge.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	 <1351283415-13170-2-git-send-email-andi@firstfloor.org>
	 <874nld8ubf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 19:08 +0900, Namhyung Kim wrote:
> That means it can support precise == 3?

It should, the difference between 2 and 3 is allowing for !EXACT_IP
samples. Not needing the LBR based fixup we should never have that, so
HSW might indeed allow for 3.
