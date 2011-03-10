Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1CJW4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:56:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CJW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:56:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wJonVjUbXdp7LRw2XX8xp+se+ofhteb5Q8/4vtCLcqGmodyU2pF8GJpYTYKhp8TyB
	m4rxLiN9aq6AS1zEL03Lg==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: [PATCH perf 0/2] perf: trace-event-parse: support more operators and print formats
Date: Thu, 10 Mar 2011 14:55:54 -0800
Message-Id: <1299797756-13546-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches correspond to similar patches recently applied to trace-cmd

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>

David Sharp (2):
  perf: trace-event-parse: support additional operators: '!', '~',  and
    '!='
  perf: trace-event-parse: support printing short fields

 tools/perf/util/trace-event-parse.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.3.1

