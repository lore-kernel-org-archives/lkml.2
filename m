Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2AWPri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:47:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2AWPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:47:37 -0500
Date: Mon, 23 Jan 2012 16:47:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@infradead.org, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken branches (v3)
Message-ID: <20120123154734.GY11715@one.firstfloor.org>
References: <1326127761-2723-1-git-send-email-eranian@google.com> <CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com> <1327321532.2446.6.camel@twins> <CABPqkBQFpyP1-gmtfJq=q1kAcc6hKPgND2uHjVBxbAPj_kK4EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBQFpyP1-gmtfJq=q1kAcc6hKPgND2uHjVBxbAPj_kK4EA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, we still need to make progress on:
>   - fixing throttling
>   - PEBS-LL

    Raw PEBS really too

>   - IBS
>   - event scheduling
>   - LWP

     - Back-to-back events

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
