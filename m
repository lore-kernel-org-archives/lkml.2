Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2DXL5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:57:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41065 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2DXL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
References: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
	<CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
	<CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
Date: Tue, 24 Apr 2012 19:57:51 +0800
Message-ID: <CAJd=RBDp1PQ8+YUBW363e0OhS+TGnZ7jyux-gRCRYmx_CXjADQ@mail.gmail.com>
Subject: Re: [PATCH] RIFS cpu scheduler
From: Hillf Danton <dhillf@gmail.com>
To: mou Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 9:38 PM, mou Chen <hi3766691@gmail.com> wrote:
>
> The SMP code is the same.The algorithum is different. :-)
>
Then would you please share the output of?

              diff -pu bfs-version rifs-version
