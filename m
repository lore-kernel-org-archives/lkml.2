Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2ILFWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:22:11 -0400
Received: from smtp2a.hushmail.com ([65.39.178.237]:39135 "EHLO
	smtp2.hushmail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751891Ab2ILFWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:22:10 -0400
X-Greylist: delayed 1848 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2012 01:22:10 EDT
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 07:51:20 +0300
To: linux-kernel@vger.kernel.org
Subject: Iptables log-level does not work with kernel 3.6-rc
From: auto75914331@hushmail.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120912045120.9E1A76F446@smtp.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rule

$IPTABLES -A RULE_0_in  -j LOG  --log-level notice --log-prefix "DENY  in: "


result with linux 3.6-rc5

Sep 12 06:37:29 xxxxx kernel: <5>DENY  in: IN=eth0 OUT= MAC=.......


result with linux 3.5.3 and older:

Sep  9 10:43:01 xxxxx kernel: DENY  in: IN=eth0 OUT= MAC......


Thanks

