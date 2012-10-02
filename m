Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2JBLl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:41:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32800 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2JBLl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:41:56 -0400
From: matthew@walster.org
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net
Subject: checkpatch run on net/ethernet
Date: Tue,  2 Oct 2012 12:41:43 +0100
Message-Id: <1349178105-28269-1-git-send-email-matthew@walster.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is my first patch, it's just a checkpatch run. I figured I would also clean up the code as there appears to be long-since-obsoleted comments and code in there.

A fairly trivial change, but worthy of inclusion IMO all the same!

Matthew Walster
