Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2APNvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:51:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56038 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab2APNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:51:37 -0500
MIME-Version: 1.0
Date: Mon, 16 Jan 2012 14:51:36 +0100
Message-ID: <CAC9WiBiaRX5v4=otjiKptqeZh0fdX_utUCq_xSrLr9ic7QFUDg@mail.gmail.com>
Subject: kbuild: ouputmakefile needs a .config
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jbeulich@novell.com, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm just wondering if the need of a .config is really needed by the
'outputmakefile' target.

If so could anybody tell me why ?

Thanks
-- 
Francis
