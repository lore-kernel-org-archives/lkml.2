Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1AJIYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:24:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60675 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1AJIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:24:41 -0500
Message-ID: <4D2AC244.4050006@monstr.eu>
Date: Mon, 10 Jan 2011 09:24:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [Patch] microblaze: remove obsolete DEBUG_BOOTMEM
References: <1294389835-18282-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1294389835-18282-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> "git grep" shows this is the last piece of code using DEBUG_BOOTMEM,
> so remove it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
