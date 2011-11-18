Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1KRTc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:32:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34305 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1KRTc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:32:57 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Chen Gong <gong.chen@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/2 v2] ramoops: use pstore interface
Date: Fri, 18 Nov 2011 11:31:36 -0800
Message-Id: <1321644698-13677-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset switches ramoops away from using /dev/mem and registers
itself as a pstore backend instead. This is built on top of needed
changes to the pstore API:

https://lkml.org/lkml/2011/11/16/342 (accepted)
https://lkml.org/lkml/2011/11/16/409 (accepted)
https://lkml.org/lkml/2011/11/17/324 (pending)

v2:
 - incorporated changes suggested by Chen Gong and Arnd Bergmann

Thanks,

-Kees

