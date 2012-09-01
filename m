Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2IAJSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:18:44 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54738 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2IAJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:10 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 00/14] staging: csr: Remove kernel version checks
Date: Sat,  1 Sep 2012 12:05:56 +0300
Message-Id: <1346490370-32438-1-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes the unneeded kernel version checks and associated
compatibility defines and macros from the csr driver.

