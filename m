Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0JYOjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:39:42 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16165 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755578Ab0JYOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:39:40 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzzz32i87h2a8h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LAUOPT-01-6ZB-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] mce, amd: code rework and cleanups
Date: Mon, 25 Oct 2010 16:03:34 +0200
Message-ID: <1288015419-29543-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set reworks code for the initial setup of MCE threshold
block registers. It adds helper functions to make functions smaller
and better to read. Finally some changes to error messages.

-Robert


