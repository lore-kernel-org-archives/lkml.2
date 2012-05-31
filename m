Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2EaSHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2EaSHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:07:47 -0400
Date: Thu, 31 May 2012 19:19:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] exit/exec && rss_stat fixes
Message-ID: <20120531171914.GA17505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

By discussion with Konstantin, 1/2 should replace

	mm-correctly-synchronize-rss-counters-at-exit-exec.patch
	mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
	mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch

Unfortunately this conflicts with another patch from Konstantin,

	mm-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch

so I am resending this (re-diffed) patch as 2/2.

Oleg.

