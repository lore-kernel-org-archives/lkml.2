Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2E1DV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:21:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34811 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2E1DVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:21:54 -0400
Message-ID: <4FC2EF4B.5020207@gmail.com>
Date: Mon, 28 May 2012 11:21:47 +0800
From: yuq <yuq825@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Run RTOS simultaneously with Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have done some work about running some RTOS simultaneously with Linux, 
the approach is running RTOS and Linux on different CPU cores. No 
modification to Linux kernel but adding a loadable kernel module. I post 
it at http://rgmp.sf.net

I want to know how you guys think about it. Any advice is welcome.

yuq
