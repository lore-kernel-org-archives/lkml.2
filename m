Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2AKQKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:10:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33963 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab2AKQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:10:30 -0500
MIME-Version: 1.0
Date: Wed, 11 Jan 2012 22:10:29 +0600
Message-ID: <CADZ9YHgCc3T1oPJ717+=2CGODqz715qCzwvEobh8yBur4E80Eg@mail.gmail.com>
Subject: [Question] sched: Should balance_iterator be removed?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Commit 4a55bd5e97b1775913 (sched: fair-group: de-couple load-balancing
from the rb-trees) added balance_iterator in cfs_rq. But, no real use
in current code. Shouldn't it be removed? Or has it been kept for
future use?

Thanks,
Rakib
