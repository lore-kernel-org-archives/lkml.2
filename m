Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1IGXOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:14:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42737 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1IGXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:14:23 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/5] perf stat --log-fd=N
Date: Wed,  7 Sep 2011 17:13:59 -0600
Message-Id: <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20110902185857.GE17970@ghostprotocols.net>
References: <20110902185857.GE17970@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Arnaldo,

Heres the "update" to the patchset I promised.

[PATCH 1/5] perf stat: add --log-fd <N> option to redirect stderr
[PATCH 2/5] perf-stat: fix +- nan% in --no-aggr runs
[PATCH 3/5] perf stat: suppress printing std-dev when its 0
[PATCH 4/5] perf stat: allow tab as cvs delimiter
[PATCH 5/5] perf stat: fix spelling in comment

Ive dropped the 'print-ops' patches for a few reasons:

- pretty and cvs outputs have diverged further, pretty has added info,
  cvs has dropped the final timing line (probably cuz it didnt fit in
  the table). I presume there are good reasons for this.

- Id be parsing with perl anyway, so cvs regularity isnt important, and
  the richer info in pretty mode is useful.

- fiddling with output format is just as likely to break somebodys parsing,
  minor aesthetic improvements arent worth it. Its easier to do nothing.
