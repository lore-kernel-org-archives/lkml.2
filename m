Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab1JFSGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:06:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965181Ab1JFSGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:06:04 -0400
Subject: Re: [PATCH 06/12] perf_events: implement PERF_SAMPLE_BRANCH for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
In-Reply-To: <1317912555-9559-7-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-7-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Oct 2011 20:05:35 +0200
Message-ID: <1317924335.29658.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c

> @@ -1046,6 +1072,9 @@ again: 

$ cat ~/.gitconfig 
[diff "default"]
                xfuncname = "^[[:alpha:]$_].*[^:]$"


Cures that. Although there's different ways too..
https://lkml.org/lkml/2011/8/25/613
