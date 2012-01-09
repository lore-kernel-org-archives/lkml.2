Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2AIGNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:13:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64896 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2AIGNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:13:45 -0500
MIME-Version: 1.0
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Mon, 9 Jan 2012 14:13:23 +0800
Message-ID: <CAE8XmWoi7MpciKfA4t+NeKAX2zZCmHbB6PCYMG4WnhGA_k5jrQ@mail.gmail.com>
Subject: Where is module target_core_stgt or forgot cleanup ?
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi NAB,
>
> In Documentation/target/tcm_mod_builder.txt, the lsmod output example
> include target_core_stgt.
>
> In drivers/target/target_core_transport.c:
>
>        ret = request_module("target_core_stgt");
>        if (ret != 0)
>                pr_err("Unable to load target_core_stgt\n");
>
> But I can not found any other source files or documents mention
> target_core_stgt.
>
> --
> Dongsheng Song

ping ?
