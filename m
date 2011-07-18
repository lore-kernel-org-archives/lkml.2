Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1GRUbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1GRUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:31:09 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com
Subject: Add an EFI pstore backend 
Date: Mon, 18 Jul 2011 16:30:24 -0400
Message-Id: <1311021033-7483-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI provides enough non-volatile storage to make it convenient for storing
crash dumps. Extend the pstore API a little to make it easier to handle
this, then add support to efivars. Some cleanup patches from Mike Waychison
then follow.

