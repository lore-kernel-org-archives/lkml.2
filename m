Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0JCJ5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 05:57:04 -0400
Received: from imr-db02.mx.aol.com ([205.188.91.96]:50089 "EHLO
	imr-db02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0JCJ5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 05:57:03 -0400
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Subject: Linux kernel 2.6.34.7 lvm error
Date: Sun, 03 Oct 2010 05:56:50 -0400
X-MB-Message-Source: WebUI
X-AOL-IP: 59.180.6.25
X-MB-Message-Type: User
MIME-Version: 1.0
From: chich21@mail.com
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: Mail.com Webmail 32679-STANDARD
Message-Id: <8CD30F86F2A0A2B-BE8-179A8@web-mmc-m02.sysops.aol.com>
X-Spam-Flag: NO
X-AOL-SENDER: chich21@mail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Linux kernel 2.6.34.7 from www.kernel.org the following error 
occurs.

Issuing this command produces error.

vgchange -ay

outputs:
Internal error: Maps lock 14317216 < unlock 14321312

vgchange is part of lvm-tools.

This doesn't happen with kernel 2.6.34 or 2.6.34.1 from www.kernel.org.

Is there a patch for 2.6.34.x series coming for this error. As there is 
one for 2.6.35.x series.

Please CC email me related posts.

Veera,
chich21@mail.com
