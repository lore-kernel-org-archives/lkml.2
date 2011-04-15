Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab1DOEAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:00:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40192 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1DOEAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E/tzJq2I9JWVktNXjHKyEULSzaumURbbtBTY8U3qW93PRRWiVwUizaWnvlGiGFPtoh
         8hU/8U5b9qWkOpCnFVfoRyC/xwEl/3n4Y81OPCUJhHBa9pjGJRn2Q1ahTv3FVtkf+5ys
         xyihaAykr6MATA7BXnP1sPsF9mR6KjjGQJizY=
MIME-Version: 1.0
In-Reply-To: <BANLkTimnjkV_df2QfirWqjW9g_tkp_pPiA@mail.gmail.com>
References: <BANLkTimnjkV_df2QfirWqjW9g_tkp_pPiA@mail.gmail.com>
Date: Fri, 15 Apr 2011 12:00:20 +0800
Message-ID: <BANLkTikZ1m-wurBVUrTjfLOK_CjdAeTwhA@mail.gmail.com>
Subject: Re: 2.6.37+ for kernel version, what is this + sign?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:12 PM, Xianghua Xiao <xiaoxianghua@gmail.com> wrote:
> After I disabled LOCALVERSION_AUTO and MODVERSIONS now the kernel
> image is 2.6.37+
> where is the + sign coming from? how can I get rid of it?
>

It comes from Makefile, which means your git tree is dirty.
You can override it by, e.g. make LOCALVERSION="" bzImage
