Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031071Ab2CVRCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:02:00 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48406 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031012Ab2CVRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:01:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] tools: Add a toplevel Makefile
Date: Thu, 22 Mar 2012 18:01:51 +0100
Message-Id: <1332435713-32143-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

this is a refresh and carve-out of an old patchset. It adds a toplevel
Makefile to tools/ so that one can build the tool of her/his liking by
simply doing

$ cd tools/
$ make <toolname>

By default, we build perf. There's also a scripts/Makefile.lib now which
should contain all make-related generic stuff which can be used by all
tools' build process after including this file.

Any comments/suggestions are welcome,
thanks.
