Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1JMOfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:35:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52126 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1JMOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8kqZJkmWzNtvYiqoFH3j9qRo2PTo58MtVON5try9vjLNsQ_Q@mail.gmail.com>
References: <CAE8kqZKQrDK4SAKc8vK7Wi46dGQBw6_LX2NFvkr-XZr_KmGhrQ@mail.gmail.com>
	<CAE8kqZJkmWzNtvYiqoFH3j9qRo2PTo58MtVON5try9vjLNsQ_Q@mail.gmail.com>
Date: Thu, 13 Oct 2011 22:35:45 +0800
Message-ID: <CAM_iQpUaQeTeaYeHt4Cgr2AsY=TvYdpDYQE--7RVGOjswu9rzQ@mail.gmail.com>
Subject: Re: [PATCH] fanotify: to differ file access event from different threads
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: boyd yang <boyd.yang@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 9:27 PM, boyd yang <boyd.yang@gmail.com> wrote:
> Does anybody review my patch and integrate into kernel?
>
>

You need to adjust your coding style to Linux kernel's,
see Documentation/CodingStyle.
