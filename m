Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab0J1CO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:14:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37582 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932457Ab0J1COz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:14:55 -0400
Date: Wed, 27 Oct 2010 22:14:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.236 for kernel 2.6.36
Message-ID: <20101028021452.GA15901@Krystal>
References: <20101026020544.GA26701@Krystal> <4CC779AE.1040506@polymtl.ca> <20101027011018.GA28612@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027011018.GA28612@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:13:51 up 35 days,  6:16,  4 users,  load average: 0.07, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
producing a highly efficient full system tracing solution.  It is composed of
several components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming.  LTTng is open source software. It is being
actively developed with the community.

Changelog:

* Fix build failure caused by inappropriate power-events CREATE_TRACEPOINTS in
  mainline.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
