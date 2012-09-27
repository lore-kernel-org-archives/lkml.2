Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2I0RBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:01:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40905 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2I0RBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:01:41 -0400
Message-Id: <20120927165958.287690622@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Sep 2012 20:59:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, hpa@zytor.com, gregkh@linuxfoundation.org,
        xemul@parallels.com, jslaby@suse.cz
Subject: [patch 0/2] Add get- ioctls to fetch some bits from tty/pty status
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For c/r we need some additional bits to fetch from terminal
connection status to be able to recreate it on restore. This
series adds appropriate ioctls. Please review, i've tested
them locally but still.

	Cyrill
