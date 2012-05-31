Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2EaAQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:16:30 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55613 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2EaAQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:16:29 -0400
Message-ID: <4FC6B85C.20201@candelatech.com>
Date: Wed, 30 May 2012 17:16:28 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Anyone successfully booted a custom kernel on Fedora 17?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably a Fedora 17 issue..but hoping someone will have mercy on me :)

I upgraded a system to Fedora 17 (from 16), and now none of my
custom-built kernels are booting.  I'm compiling the kernels on
another machine, running the 'make modules install', tarring everything
up, and then running 'mkinitrd ...' after un-tarring on the F17 machine.

The F17 machine hangs right before it should begin starting services.

I tried 3.3.7+, 3.0.32+, etc.  The kernels that come with F17 boot fine.

If anyone has any ideas, please let me know.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

