Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab2DAMFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:05:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2DAMFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAO_0yfNV+rabyL95=i8EHJb0BgY+QCGS_30_9eebx9AKEOOnbQ@mail.gmail.com>
References: <1333279918-29466-1-git-send-email-prarit@redhat.com>
	<CAO_0yfNV+rabyL95=i8EHJb0BgY+QCGS_30_9eebx9AKEOOnbQ@mail.gmail.com>
Date: Sun, 1 Apr 2012 20:05:22 +0800
Message-ID: <CAM_iQpWYWiztkH1aJ3vB3rJqnfxj1PZt3WoRW8iYr2TZhp5xug@mail.gmail.com>
Subject: Re: [PATCH] scripts, Fix 'make cscope'
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Yang Bai <hamo.by@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 7:56 PM, Yang Bai <hamo.by@gmail.com> wrote:
>
> But this does not fix the real problem and introduce the origin
> problem of make TAGS back.
>
> Could you try this patch?

There was already a same patch:
https://lkml.org/lkml/2012/4/1/12
