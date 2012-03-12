Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2CLPNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:13:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54252 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab2CLPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:13:48 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 0/2] perf report: fix branch view mode glitches
Date: Mon, 12 Mar 2012 16:13:28 +0100
Message-Id: <1331565210-10865-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series fixes the following two glitches in perf report
while in branch view mode:
 - duplicate annotation choice in case the branch source and target
   are in the same function

 - go back two levels when pressing 'q' while annotating

Signed-off-by: Stephane Eranian <eranian@google.com>

Stephane Eranian (2):
  perf report: remove duplicate annotate choice in branch view mode
  perf report: fix annotate double quit issue in branch view mode

 tools/perf/util/ui/browsers/hists.c |   40 ++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 7 deletions(-)

-- 
1.7.4.1

