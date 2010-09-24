Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0IXTLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:11:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56363 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0IXTLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:11:53 -0400
MIME-Version: 1.0
X-Originating-IP: [192.94.94.106]
Date: Fri, 24 Sep 2010 14:11:50 -0500
X-Google-Sender-Auth: r9Nc955Qk7XMYZv5oOmQmEaEI_c
Message-ID: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
Subject: drivers:staging:ti-st: merge issues.
From: Pavan Savoy <pavan_savoy@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

The merges bbf96b3cb54a237f1a66883390637e30bb4407ba and the merge on
759b9f0fe0c5be0d9fa1b92e14e093961312f6ac has caused the
drivers/staging/ti-st to get corrupted, I had submitted few patches
and it was all merged.

basically the merge for bbf96b3cb54a237f1a66883390637e30bb4407ba for
drivers/staging/ti-st/ shouldn't have happened.
The head for the drivers/staging/ti-st/ should have been @
83ef41f0858b48cce4f8ca23f674ec55d50bf47d

This is causing build failure.
