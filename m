Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab1IWU3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:29:09 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:57806 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1IWU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:29:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1316809699!1895627!62
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dlm/ast.c: include ast.h to pickup function definitions
Date: Fri, 23 Sep 2011 13:28:54 -0700
User-Agent: KMail/1.9.9
CC: <cluster-devel@redhat.com>, <ccaulfie@redhat.com>, <teigland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231328.55055.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the following sparse noise:

warning: symbol 'dlm_add_lkb_callback' was not declared. Should it be static?
warning: symbol 'dlm_rem_lkb_callback' was not declared. Should it be static?
warning: symbol 'dlm_add_cb' was not declared. Should it be static?
warning: symbol 'dlm_callback_work' was not declared. Should it be static?
warning: symbol 'dlm_callback_start' was not declared. Should it be static?
warning: symbol 'dlm_callback_stop' was not declared. Should it be static?
warning: symbol 'dlm_callback_suspend' was not declared. Should it be static?
warning: symbol 'dlm_callback_resume' was not declared. Should it be static?

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>

---

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 90e5997..43f33c0 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -12,6 +12,7 @@
 ******************************************************************************/
 
 #include "dlm_internal.h"
+#include "ast.h"
 #include "lock.h"
 #include "user.h"
 
