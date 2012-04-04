Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2DDW1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:27:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DDW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:27:24 -0400
Date: Wed, 4 Apr 2012 15:27:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [rtc-linux] [PATCH 2/2 RFC] rtc-pcf8563: Add
 RTC_VL_READ/RTC_VL_CLR ioctl feature
Message-Id: <20120404152722.2f026ba6.akpm@linux-foundation.org>
In-Reply-To: <1329236025-31323-2-git-send-email-alexander.stein@systec-electronic.com>
References: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
	<1329236025-31323-2-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 17:13:45 +0100
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> Changes are based on arch/cris/arch-v10/drivers/pcf8563.c
> 
>  drivers/rtc/rtc-pcf8563.c |   44 +++++++++++++++++++++++++++++++++++++++++++-

um, why does the kernel have two drivers for the same device?

arch/cris/arch-v10/drivers/pcf8563.c reimplements some of drivers/rtc/rtc-lib.c :(
