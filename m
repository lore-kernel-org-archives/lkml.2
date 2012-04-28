Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2D1Bib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:38:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62732 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2D1Bia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:38:30 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXhQYnCn7b2fL_eBRf+QNPb4p2HLUZgcDs3VVeB51=6xpg@mail.gmail.com>
References: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
	<CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
	<CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
	<CAJd=RBDp1PQ8+YUBW363e0OhS+TGnZ7jyux-gRCRYmx_CXjADQ@mail.gmail.com>
	<CANQmPXgUb4UzXfJOTgFD9T=nSFOu7WGvPEmSpFBu-nSThUZaPg@mail.gmail.com>
	<CANQmPXhQYnCn7b2fL_eBRf+QNPb4p2HLUZgcDs3VVeB51=6xpg@mail.gmail.com>
Date: Sat, 28 Apr 2012 09:38:29 +0800
Message-ID: <CAJd=RBAYStGWyKVPfBNeT3bY9AB5Muoyx4L8o3aVjDJSEKWsdw@mail.gmail.com>
Subject: Re: [PATCH] RIFS cpu scheduler
From: Hillf Danton <dhillf@gmail.com>
To: mou Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 4:25 PM, mou Chen <hi3766691@gmail.com> wrote:
>
> RIFS is not using any fomula and the algorithum RIFS use is simple and
> it works very well with make -j64.There is no lagging with firefox.
>
Yes, and diff -pu bfs.c rifs.c could simplify a few more, right?
