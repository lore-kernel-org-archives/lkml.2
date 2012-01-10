Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2AJCCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:02:40 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56948 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2AJCCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:02:38 -0500
Subject: Re: Where is module target_core_stgt or forgot cleanup ?
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAE8XmWoi7MpciKfA4t+NeKAX2zZCmHbB6PCYMG4WnhGA_k5jrQ@mail.gmail.com>
References: <CAE8XmWoi7MpciKfA4t+NeKAX2zZCmHbB6PCYMG4WnhGA_k5jrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 18:02:36 -0800
Message-ID: <1326160956.6802.76.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 14:13 +0800, Dongsheng Song wrote:
> > Hi NAB,
> >
> > In Documentation/target/tcm_mod_builder.txt, the lsmod output example
> > include target_core_stgt.
> >
> > In drivers/target/target_core_transport.c:
> >
> >        ret = request_module("target_core_stgt");
> >        if (ret != 0)
> >                pr_err("Unable to load target_core_stgt\n");
> >
> > But I can not found any other source files or documents mention
> > target_core_stgt.
> >
> > --
> > Dongsheng Song
> 
> ping ?

Hello,

target_core_stgt is a backend driver for a userspace passthrough using
STGT logic that exists in lio-core.git code.  It's only WIP code in it's
current form, and until someone shows interest in doing the necessary
work to make it run it's going to remaine a lio-core.git specific
module.

--nab


