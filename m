Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab2HPQWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:22:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16667 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab2HPQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] Various cleanups in the code base found with sparse (v1) for v3.7.
Date: Thu, 16 Aug 2012 12:12:32 -0400
Message-Id: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been starting to run sparse to make sure we are not introducing
any potential issues. It does not report any in the Xen code-base but it
does reports a bit of the warnings so these take care of removing them.

Most of the warnings were of the type : <function or value> not declared.

And in some cases they just needed to be converted to 'static' or
the header file included in the C code.

