Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1KPV0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:26:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47763 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1KPV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:26:00 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/2] ramoops: use pstore interface
Date: Wed, 16 Nov 2011 13:25:37 -0800
Message-Id: <1321478739-8978-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset switches ramoops away from using /dev/mem and registers
itself as a pstore backend instead. This is built on top of needed changes
to the pstore API:

https://lkml.org/lkml/2011/11/16/342
https://lkml.org/lkml/2011/11/16/409

Thanks,

-Kees

