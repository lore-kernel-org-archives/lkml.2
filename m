Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1CZBSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:18:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44733 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752360Ab1CZBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:33 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19gtCAjfYhg7JASOXliADd8GdJEDhqD6lltpeZOPC
	mk2K1wsHA+oCOZ
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 0/27] staging/trivial: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:49 +0100
Message-Id: <1301102296-15565-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some very common spelling mistakes in drivers/staging
The changes are now split up by directories in drivers/staging.
Each patch mentions which particular spelling error was fixed for the
particular directory/driver.

The changes were carried out by hand and are made in
documentation/comments only - no functional change.
Variables were left untouched on purpose.
Linebreaks were also left untouched on purpose.

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
