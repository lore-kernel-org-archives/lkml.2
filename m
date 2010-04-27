Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0D0Wst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:48:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757362Ab0D0Wss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:48:48 -0400
Date: Tue, 27 Apr 2010 15:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] tosa_battery: fix FTBFS bug due to driver_data access
Message-Id: <20100427154835.27bdc233.akpm@linux-foundation.org>
In-Reply-To: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
References: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 17:18:22 +0400
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/power/tosa_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Please don't send unchangelogged patches.

Please don't send patches which require recipients to go googling
acronyms to work out wtf you're up to.

<googles the acronym>

Ah, it appears to be a build fix.

Please always quote the compiler errors when fixing a build error.

IOW: bah.

