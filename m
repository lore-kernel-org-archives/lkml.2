Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0FOPzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:55:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55229 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0FOPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:55:07 -0400
Date: Tue, 15 Jun 2010 08:54:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 15 (video/uvc & gadget/webcam)
Message-Id: <20100615085443.e49beae5.randy.dunlap@oracle.com>
In-Reply-To: <20100615150907.5fb984da.sfr@canb.auug.org.au>
References: <20100615150907.5fb984da.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C17A252.0211:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 15:09:07 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100614:

(FYI)

CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_G_WEBCAM=y

(.text+0x1b72a0): multiple definition of `uvc_queue_poll'
(.text+0x1b74a0): multiple definition of `uvc_queue_buffer'
(.text+0x1b7030): multiple definition of `uvc_queue_cancel'
(.text+0x1b7140): multiple definition of `uvc_queue_enable'
(.text+0x1b82b0): multiple definition of `uvc_alloc_buffers'
(.text+0x1b8070): multiple definition of `uvc_query_buffer'
(.text+0x1b85c0): multiple definition of `uvc_queue_init'
(.text+0x1bfa60): multiple definition of `uvc_video_init'
(.text+0x1b7c90): multiple definition of `uvc_dequeue_buffer'
drivers/media/built-in.o:(.bss+0x73a04): multiple definition of `uvc_trace_param'
(.text+0x1bf6e0): multiple definition of `uvc_video_enable'
(.text+0x1b8140): multiple definition of `uvc_free_buffers'
(.text+0x1b6e50): multiple definition of `uvc_queue_next_buffer'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
