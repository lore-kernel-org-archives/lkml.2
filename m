Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2EAKfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:35:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:58491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2EAKfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:35:09 -0400
Message-ID: <1335868497.13683.123.camel@twins>
Subject: Re: [PATCH RFC v2] lib: Proportions with flexible period
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>
Date: Tue, 01 May 2012 12:34:57 +0200
In-Reply-To: <1335285033-7347-2-git-send-email-jack@suse.cz>
References: <1335285033-7347-1-git-send-email-jack@suse.cz>
	 <1335285033-7347-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 18:30 +0200, Jan Kara wrote:
> Implement code computing proportions of events of different type (like code in
> lib/proportions.c) but allowing periods to have different lengths. This allows
> us to have aging periods of fixed wallclock time which gives better proportion
> estimates given the hugely varying throughput of different devices - previous
> measuring of aging period by number of events has the problem that a reasonable
> period length for a system with low-end USB stick is not a reasonable period
> length for a system with high-end storage array resulting either in too slow
> proportion updates or too fluctuating proportion updates.


OK, seems sound. Thanks!
