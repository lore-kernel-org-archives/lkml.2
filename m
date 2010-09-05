Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0IES7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:59:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35454 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0IES7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:59:34 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/8] Fix unsigned return type
Date: Sun,  5 Sep 2010 21:00:18 +0200
Message-Id: <1283713226-8429-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix some cases where a negative constant is returned from a
function that has an unsigned return type.  In most cases, the result of
every call to the function is stored in a signed variable, and thus the
unsigned in the return type can just dropped.

