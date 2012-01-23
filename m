Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2AWPHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:07:14 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49121 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2AWPHN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:07:13 -0500
MIME-Version: 1.0
In-Reply-To: <1327321532.2446.6.camel@twins>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
	<CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com>
	<1327321532.2446.6.camel@twins>
Date: Mon, 23 Jan 2012 16:07:11 +0100
Message-ID: <CABPqkBQFpyP1-gmtfJq=q1kAcc6hKPgND2uHjVBxbAPj_kK4EA@mail.gmail.com>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken
 branches (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, 2012-01-23 at 11:14 +0100, Stephane Eranian wrote:
> > Any comments on this patch set?
> >
> Queued it, thanks!


Great Thanks.

Now, we still need to make progress on:
  - fixing throttling
  - PEBS-LL
  - IBS
  - event scheduling
  - LWP
