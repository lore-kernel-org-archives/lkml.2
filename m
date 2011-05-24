Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1EXOZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:25:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56882 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1EXOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uq7DLmuGYtpRUoqiLRRl5iPDQ1CQqk5/W5+AKaJbZDS1TAKxUcE5R+JZYzGvvR5j5x
         DrhlpASu+Wm82bQ7XW1jHLVn2BoXB5SNNMuOe7SOjJPSe5t7h5WvrmbD7WzhXX4xMyjT
         qiCqQI/+zyutblf8dkJdNfe+r4+wzs2+d739Q=
Subject: [PATCH] MIPS:i8259.c remove resume and shutdown to syscore_ops
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Pengfei Zhang <zoppof.zhang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Tue, 24 May 2011 22:25:12 +0800
Message-ID: <1306247112.2066.8.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, May 24, 2011 at 08:19:18PM +0800, Pengfei Zhang wrote:
> 
> > Remove the resume and shutdown of i8259A from the sysdev_class
> > to the syscore_ops since these members had removed from the
> > structure sysdev_class.
> 
> I don't see why one would want to want to first call
> register_syscore_ops
> then sysdev_class_register and sysdev_register?
> 
Hi Ralf:
If these not moved to syscore_ops, building will get error.

Hi Thomas:
Does you mean that we can just remove the sysfs entry now ?


Thanks
Best regards

Wanlong Gao

