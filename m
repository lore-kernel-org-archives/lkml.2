Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0LAMGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:06:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61784 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0LAMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:06:02 -0500
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 12:05:58 +0000
X-Google-Sender-Auth: c0RvQ5o70Xw0KxTfvAKeimw2jlM
Message-ID: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
Subject: Problems using EXPORT_SYMBOL with lib/flex_array
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to be able to use the flex_array functions in my module so I
wanted to EXPORT_SYMBOL the API.

I added the appropriate EXPORT_SYMBOL runes into lib/flex_array.c and
added externs in the header files but after re-building there is still
no sign of them in Module.symvers.

I've done a make clean, reset the whole repo to ensure the tree is
clean from previous builds and I'm still seeing problems. Am I being a
little dim or is there some other magic foo that needs doing to add an
export to a library function?

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
