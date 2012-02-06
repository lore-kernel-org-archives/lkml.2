Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2BFQR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:17:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2BFQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:17:25 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Updated throttling fix patchkit
Date: Mon,  6 Feb 2012 08:17:07 -0800
Message-Id: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated patchkit to fix ACPI thermal zone throttling and some
related problems. See the individual patches for more details.

Changes to the earlier version:

- Address earlier review comments
- Fix package index computation
- Shut up Intel IPS driver

This is ready for merging now.

-Andi

