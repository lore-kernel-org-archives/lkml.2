Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0HIQVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:21:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:41258 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab0HIQVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:21:44 -0400
Date: Mon, 09 Aug 2010 12:21:40 -0400
Message-Id: <E1OiV6a-0004qU-7R@tytso-glaptop>
To: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org
Subject: v2.6.35-git2 SELinux build failure
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit b782e0a6, introduced in v2.6.35-git2, uses FILE__AUDIT_ACCESS
without actually defining it:

security/selinux/hooks.c:2644: error: ‘FILE__AUDIT_ACCESS’ undeclared
(first use in this function)

I first noticed this in 2.6.35-git6, and it is still broken in
2.6.35-git7.  I'm not sure how SELinux got turned on in my config, but
I'm not using it, so I'm going to fix it by turning off SELinux.  I
thought I would mention it first, though.

					- Ted
