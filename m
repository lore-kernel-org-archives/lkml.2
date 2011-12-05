Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1LEQ2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:28:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1LEQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:28:49 -0500
MIME-Version: 1.0
Date: Tue, 6 Dec 2011 00:28:48 +0800
Message-ID: <CABexPfE84OgdGQtKUm2JQ9_5ZBFs_pr3gdxMLYmxd=wVyBZhpQ@mail.gmail.com>
Subject: [Page Allocator] when is init_per_zone_wmark_min called to first
 initialize the watermarks, reserved memory etc?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

        I'm reading the linux kernel codes, and now focusing on memory
management. I came across a simple problem:).
        I know the every zone keeps three water marks to control the
allocator's behavior and I find the three watermarks is initialized in
init_per_zone_wmark_min.
Unfortunately, I can't find when this function is called FIRSTduring
the kernel booting process. I searched the source codes using LXR and
cscope and got nothing.
I guess I missed something but I have no any idea.

harvey.
