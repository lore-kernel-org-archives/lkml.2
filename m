Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1ARTbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:31:02 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40029 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1ARTbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:31:00 -0500
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/9 v2] Altera FPGA based CI driver module.
Date: Tue, 18 Jan 2011 21:23:31 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.37-smp+; KDE/4.4.3; i686; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4d20723d.cc7e0e0a.6f59.3762@mx.google.com> <4D333066.3020203@infradead.org>
In-Reply-To: <4D333066.3020203@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101182123.31987.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от 16 января 2011 19:52:38 автор Mauro Carvalho Chehab написал:
> Em 02-01-2011 10:01, Igor M. Liplianin escreveu:
> > An Altera FPGA CI module for NetUP Dual DVB-T/C RF CI card.
> > 
> > Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
> 
> Igor,
> 
> There's something wrong with this patch. I got lots of error after applying
> it:
> 
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_read_attribute_mem':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:304:
> multiple definition of `netup_ci_read_attribute_mem'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:241: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_op_cam':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:269:
> multiple definition of `netup_ci_op_cam'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:171: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_slot_shutdown':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:364:
> multiple definition of `netup_ci_slot_shutdown'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:293: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_slot_ts_ctl':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:370:
> multiple definition of `netup_ci_slot_ts_ctl'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:320: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_write_cam_ctl':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:322:
> multiple definition of `netup_ci_write_cam_ctl'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:259: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_read_cam_ctl':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:315:
> multiple definition of `netup_ci_read_cam_ctl'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:252: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_write_attribute_mem':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:310:
> multiple definition of `netup_ci_write_attribute_mem'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:247: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_poll_ci_slot_status':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:448:
> multiple definition of `netup_poll_ci_slot_status'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:403: first defined here
> drivers/media/video/cx23885/altera-ci.o: In function
> `netup_ci_slot_reset':
> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:327:
> multiple definition of `netup_ci_slot_reset'
> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
> a/video/cx23885/cimax2.c:264: first defined here
> 
> 
> Please fix it and submit a new version. The better is to replace all those
> new symbols to start with altera_ci.
I see, allyesconfig...

> 
> While here, please, on the first patch, move the Altera FPGA driver to
> staging, to give people some time do discuss about it.
It means that cx23885 driver will depend on staging. Is it OK?

> 
> PS.: there are a few CodingStyle errors on this patch. Please always review
> your patches with ./scripts/checkpatch.pl.
I'll do it.
> 
> Thanks!
> Mauro

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
