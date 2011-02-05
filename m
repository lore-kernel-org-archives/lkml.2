Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1BERqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:46:55 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39848 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab1BERqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:46:54 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH -V2 0/17] Buffered write and writeable mmap support for 9P
Date: Sat,  5 Feb 2011 23:16:28 +0530
Message-Id: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series implement buffered write and writeable mmap for 9P

Changes from V1:
a) Add fsync and syncfs support

-aneesh

