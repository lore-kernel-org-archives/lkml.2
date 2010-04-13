Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0DMH0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:26:21 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62150 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0DMH0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:26:20 -0400
Message-ID: <4BC41C97.7090301@monstr.eu>
Date: Tue, 13 Apr 2010 09:26:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Quiet section mismatch warnings
References: <1270868617-16551-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1270868617-16551-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> _start is located in .text, which causes mismatch warnings with 
> machine_early_init() and start_kernel() in .init.text.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---

Added to next branch. I also fix mismatch for MMU kernel

Thanks.
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
