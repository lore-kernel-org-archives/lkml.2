Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2A0Aih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:38:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58433 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2A0Aie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:38:34 -0500
From: Kees Cook <kees@ubuntu.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 0/4] AppArmor: refactor securityfs to use structures
Date: Thu, 26 Jan 2012 16:29:19 -0800
Message-Id: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ground-work for expanding the AppArmor securityfs to include
useful information that the userspace tools can more easily interact with.
Presently, this is only static information about the state of AppArmor.

-Kees

