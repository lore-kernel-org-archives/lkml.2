Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1KYJcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 04:32:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39466 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1KYJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 04:32:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111125081959.GA2505@darkstar.nay.redhat.com>
References: <20111125081959.GA2505@darkstar.nay.redhat.com>
Date: Fri, 25 Nov 2011 17:32:15 +0800
Message-ID: <CAM_iQpW7WXeUihgbJneJUJ1GAMzXfONfV69dpqeRbUt_781M=Q@mail.gmail.com>
Subject: Re: [PATCH] kexec: do not call kmsg_dump in crashdump
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dave Young <dyoung@redhat.com>
Cc: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 4:19 PM, Dave Young <dyoung@redhat.com> wrote:
> mtd/ram oops dumper will make more functions envolved. In case crash kexec,
> we should avoid kmsg dumper to ensure crashdump success.
>
> kill kmsg_dump callback while crash dumping

https://lkml.org/lkml/2011/2/1/33
