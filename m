Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2DFCTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 22:19:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55156 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2DFCTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 22:19:20 -0400
MIME-Version: 1.0
Date: Fri, 6 Apr 2012 10:19:19 +0800
Message-ID: <CANudz+uhw4LZ4EoDvp_eC2K23=Qm_ACPpM8TRq5p0t9=idKcSg@mail.gmail.com>
Subject: Some questions about high memory
From: loody <miloody@gmail.com>
To: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
I am trying to write a driver for my block device which dma support
high memory copying.
I have register my device as "blk_bounce_any".
But my driver cannot see block layer pass high memory to me so far.

Is there any user/kernel test program which will purposely send high
memory for driver to use?
or is there any flag when opening a file in user mode that will use high memory?

-- 
Thanks for your help in advance,
