Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2FPMvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:51:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2FPMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339821655-14059-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com> <1339821655-14059-2-git-send-email-yuanhan.liu@linux.intel.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 16 Jun 2012 14:50:53 +0200
Message-ID: <CAPXgP130QzSzPObbDedqMLc2Fw6CgzJNW56ccQeRPmZPp27JOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] printk: return -EINVAL if the message len is bigger
 than the buf size
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, wfg@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 6:40 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> Just like what devkmsg_read() does, return -EINVAL if the message len is
> bigger than the buf size, or it will trigger a segfault error.

Looks good to me.

Thanks,
Kay
