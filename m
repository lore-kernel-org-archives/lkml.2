Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309Ab1JFSx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:53:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:45656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab1JFSx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:53:58 -0400
Subject: Re: [PATCH 08/12] perf_events: disable PERF_SAMPLE_BRANCH_* when
 not supported
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 20:53:47 +0200
In-Reply-To: <1317912555-9559-9-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-9-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317927227.9813.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> PERF_SAMPLE_BRANCH_* is disabled for:

> - ALL but Intel X86 architecture
> - AMD64 processors
> 
It would be good if you could CC all arch/*/kernel/perf_event*
maintainers on this, that way they are aware of the existence of the
feature. Maybe one of them can actually support some of this.. who
knows ;-)

Robert, does this Fam15 thing have anything useful in this regards?
