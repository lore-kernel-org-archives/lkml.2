Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab1JFQ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:57:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab1JFQ5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:57:41 -0400
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 18:57:21 +0200
In-Reply-To: <1317912555-9559-2-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317920241.29658.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
>  struct perf_branch_entry {
>         __u64                           from;
>         __u64                           to;
> +       struct {
> +               __u64                   mispred:1,  /* target mispredicted */
> +                                       predicted:1,/* target predicted */
> +                                       reserved:62;
> +       };
>  }; 

Why that anonymous structure?
