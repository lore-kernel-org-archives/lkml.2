Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2CETBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:01:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63962 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2CETBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:01:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of maciej.rutecki@gmail.com designates 10.213.111.6 as permitted sender) smtp.mail=maciej.rutecki@gmail.com; dkim=pass header.i=maciej.rutecki@gmail.com
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] 3.3-rc6: Reported regressions from 3.2
Date: Mon, 5 Mar 2012 20:01:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1203051056560.1847-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1203051056560.1847-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203052001.08408.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 5 marca 2012 o 17:04:38 Alan Stern wrote:
> This has been fixed by commits 2885e25c422fb68208f677f944a45fce8eda2a3c
> and 29bb5d4fd3140a7d5d02d858118c74a45f15c296


Thanks. Closing bug.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
