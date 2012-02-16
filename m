Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2BPCek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:34:40 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50426 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab2BPCej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:34:39 -0500
MIME-Version: 1.0
Date: Thu, 16 Feb 2012 10:34:37 +0800
Message-ID: <CAADzPW2sTjQbkOgPcAS9zWZz3jveQeaXK7cAxZVBtQ6no_paZQ@mail.gmail.com>
Subject: Question: how to make one page readonly on ARM
From: =?UTF-8?B?5pmB5rC455Sf?= <chaoys155@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I get one page by __get_free_page(), and I can make it readonly by
set_memory_ro on X86,
how to do this on ARM?

-- 
Thanks a lot!
