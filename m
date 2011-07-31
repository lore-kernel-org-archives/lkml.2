Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1GaG4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 02:56:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51703 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1GaG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 02:56:31 -0400
MIME-Version: 1.0
Date: Sun, 31 Jul 2011 08:56:30 +0200
Message-ID: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
Subject: v3.0: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing those kernel message when resuming:

[  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
[  524.973288] Do you have a strange power saving mode enabled?
[  524.973289] Dazed and confused, but trying to continue

I don't know if it's important or not because the system seems to work
after but maybe it worths to report

-- 
Francis
