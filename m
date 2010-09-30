Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0JDPXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0JDPXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:23:15 -0400
Date: Thu, 30 Sep 2010 16:19:14 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] lirc: Make struct file_operations pointer const
Message-ID: <20100930201914.GD8135@redhat.com>
References: <alpine.DEB.2.00.1009302153210.2434@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009302153210.2434@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 09:55:07PM +0200, Geert Uytterhoeven wrote:
> struct file_operations was made const in the drivers, but not in struct
> lirc_driver:
> 
> drivers/staging/lirc/lirc_it87.c:365: warning: initialization discards qualifiers from pointer target type
> drivers/staging/lirc/lirc_parallel.c:571: warning: initialization discards qualifiers from pointer target type
> drivers/staging/lirc/lirc_serial.c:1073: warning: initialization discards qualifiers from pointer target type
> drivers/staging/lirc/lirc_sir.c:482: warning: initialization discards qualifiers from pointer target type
> drivers/staging/lirc/lirc_zilog.c:1284: warning: assignment discards qualifiers from pointer target type
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Whoops, yeah, obvious fix.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

