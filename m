Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1GLImK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:42:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:45368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1GLImI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:42:08 -0400
Subject: perf error codes
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>, Stephane Eranian <eranian@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, paulus <paulus@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 10:41:41 +0200
Message-ID: <1310460101.18678.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane, Vince,

Linus recently expressed dislike of our -ENOSPC usage for indicating the
pmu is 'full'. Do either of your projects (libpfm, libpapi resp.) rely
on this particular error code for this condition?


