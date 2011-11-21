Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1KUCSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 21:18:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42247 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1KUCSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 21:18:01 -0500
MIME-Version: 1.0
Date: Sun, 20 Nov 2011 21:18:00 -0500
Message-ID: <CALKntY135akw4khsrbVdk2L-YgF0aYsaHw6Lhf7n4gU6MTrZuQ@mail.gmail.com>
Subject: Running Application Inside Application
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applications that do not install signal handlers I need it to
install. Therefore, I am thinking about having a light-weight run-time
to load the application ELF file and install the needed signal handler
in the run-time ? Is this doable ? What if it is not ELF-encoded ?

Thanks

Xin
