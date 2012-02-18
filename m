Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2BRCHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:07:23 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:51455 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295Ab2BRCHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:07:22 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        andreiw@vmware.com
Subject: Usability non-serial console sessions.
Date: Fri, 17 Feb 2012 21:07:14 -0500
Message-Id: <1329530836-23958-1-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches address a couple of issues I found
when trying to use kdb from a vga+kbd session. Both
are related to custom-defined commands and the LINES
environment variable.

[PATCH 1/2] KDB: Make LINES an internal variable.
[PATCH 2/2] KDB: Overide LINES for custom commands.

Thank you for your feedback,
A
