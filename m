Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0JMJb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:31:56 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51757 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab0JMJbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:31:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] MCE decoding on F12h
Date: Wed, 13 Oct 2010 11:31:36 +0200
Message-Id: <1286962300-23385-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Here are 4 almost trivial patches enabling MCE
decoding on AMD F12h CPUs ontop of the stuff from
http://marc.info/?l=linux-kernel&m=128627598630356&w=2. Almost trivial
because they're a subset of F10h and are reusing old functionality.

Since they're simple enough I'll add them to linux-next through

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next

and will send them to Linus sometime next week after successful
simmering in linux-next for a week or so.
