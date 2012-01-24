Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2AXOnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:43:49 -0500
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:59156 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2AXOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:43:48 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: eparis@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: Q. private_destroy_list in fsnotify_mark_destroy()
Date: Tue, 24 Jan 2012 23:43:43 +0900
Message-ID: <1318.1327416223@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Eric Paris,

In fsnotify_mark_destroy(), private_destroy_list is replaced by global
destroy_list, and the function calls fsnotify_put_mark() for each
fsnotify mark.
And waits for the global destroy_list becomes empty.
Should it be private_destroy_list? I am afraid the fsnotify_mark_destroy
kthread may cause a deadlock.


J. R. Okajima
