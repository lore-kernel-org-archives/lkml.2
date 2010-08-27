Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0H0F5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:57:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59066 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0H0F5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:57:43 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/3] Remove potential NULL dereference
Date: Fri, 27 Aug 2010 07:57:17 +0200
Message-Id: <1282888640-27042-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches find a case where there is a dereference before a NULL test
and either move the dereference after the NULL test, or eliminate the NULL
test if it seems unnnecessary.

