Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2ELGpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 02:45:09 -0400
Received: from mail.agmk.net ([91.192.224.71]:34468 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2ELGpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 02:45:07 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 May 2012 02:45:07 EDT
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Sat, 12 May 2012 08:36:43 +0200
Message-ID: <2598499.YYnUQlf0Se@localhost>
User-Agent: KMail/4.8.3 (Linux/3.3.5-1; KDE/4.8.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fyi, this release contains a hidden strict-aliasing-violation bug [1].
please fix this correctly or build mdadm with -fno-strict-aliasing option.

[1] http://www.spinics.net/lists/raid/msg37298.html

