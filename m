Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031223Ab2CUOfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:35:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42145 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab2CUOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:35:00 -0400
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 0/2] perf: Add persistent event facilities
Date: Wed, 21 Mar 2012 15:34:54 +0100
Message-Id: <1332340496-21658-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi guys,

this is yet another version of the persistent events patch incorporating
all comments from last time. Highlights in this version are the switch
to the other ring buffer, making the facility generic for usage by other
subsystems not only RAS (patch 2/2 shows an exemplary usage) and a
couple of minor simplifications.

Any comments and suggestions are welcome,
thanks.
