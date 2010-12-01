Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0LAPLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:11:12 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:47544 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0LAPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:11:11 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCH 0/4] trivial header fixes
Date: Wed,  1 Dec 2010 17:10:41 +0200
Message-Id: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These four patches contain trivial headers_check warnings in current kernel.
Two of them were obtained with a patch to headers_check [1] that slightly
improves its ability to detect exported function prototypes.

[1] http://marc.info/?l=linux-kernel&m=129113414531152&w=2

Regards,
--
Alex
