Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab1KMMLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 07:11:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50169 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1KMMLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 07:11:45 -0500
MIME-Version: 1.0
Date: Sun, 13 Nov 2011 07:11:45 -0500
Message-ID: <CALKntY2A5AAc0r87rX64yQEBZZTjhra=SQk9qnjKPRZJPF6s8w@mail.gmail.com>
Subject: module_init in linux kernel
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one is writing a module, are module_init and module_exit
mandatory. I understand that module_init and module_exit are just
macro which place functions in special .text area. Is there is not
module_init or module_exit defined, is there any default to take over
or the kernel will panic when the module is loaded.

Thanks

Xin
