Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2LJLLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:11:10 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43993 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2LJLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:11:08 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 16:41:07 +0530
Message-ID: <CAEZ9+qkNEw1tnD+FVvL9HGgJksZwieX-15rnixxyccGBQEbZhA@mail.gmail.com>
Subject: Query on maximum char dynamic major numbers can be allocated
From: Mohan Reddy Koppula <mohanreddykv@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to allocate major numbers dynamically around 255 for char
drivers. After some time I got -EBUSY error. I read the code and found
that maximum major numbers we can allocate dynamically  is 255, is
that true?. What else if I want to allocate major numbers dynamically
more than 255. Please let me know.

Thanks,
Venkat
