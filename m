Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1CGXcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:32:43 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53792 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1CGXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:32:42 -0500
Subject: target: Remaining for-38 regression bugfix
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 15:25:55 -0800
Message-Id: <1299540355.19683.344.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

At this point there is still one critical regression bugfix caused by
the target_core_cdb.c v4.0 refactoring from Christoph that needs to go
in ASAP.  Please make sure the following patch is included into your
final for-38 scsi-rc-fixes pull request for Linus.

target: Fix READ_CAPACITY_16 regression
http://marc.info/?l=linux-kernel&m=129911001806783&w=2

Please let me know if you have any questions,

--nab

