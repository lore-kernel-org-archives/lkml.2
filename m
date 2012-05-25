Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2EYWMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:12:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45466 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2EYWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:12:10 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 18:12:10 -0400
Message-ID: <CALKntY1wDFxzZX6ONgeVuNjBxi=bPA-0vhWJ-_NMXR37GNmvBQ@mail.gmail.com>
Subject: native_save_fl taking good amount of time in profile
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have collected a profile on the whole system. But the only thing
that is really running is a mysql database server. I have noticed that
there is a function in kernel that took 5% of the overall running
time. what does native_save_fl do ? does it make sense that
native_save_fl takes the most amount of time among all kernel
functions ?


Thank
