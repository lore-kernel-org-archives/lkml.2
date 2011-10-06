Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab1JFSue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:50:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:45590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab1JFSuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:50:32 -0400
Subject: Re: [PATCH 10/12] perf: add code to support PERF_SAMPLE_BRANCH_STACK
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Thu, 06 Oct 2011 20:50:18 +0200
In-Reply-To: <1317912555-9559-11-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-11-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317927018.9813.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:

Is a From: Roberto ..

Line missing here?

> This patch adds:
> - ability to parse samples with PERF_SAMPLE_BRANCH_STACK
> - sort on branches
> - build histograms on branches
> 
> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> Signed-off-by: Stephane Eranian <eranian@google.com> 
