Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2GCLVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:21:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2GCLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120703104511.GA29501@elgon.mountain>
References: <20120703104511.GA29501@elgon.mountain>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Jul 2012 13:21:01 +0200
Message-ID: <CAPXgP10e5cuNnOqGgBtZQq-6sZ2bpjySbd7thZyLNdij77oaHg@mail.gmail.com>
Subject: Re: [patch] printk: remove some dead code
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 12:45 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Static checkers complain about the impossible condition here.
>
> In 084681d14e ('printk: flush continuation lines immediately to
> console'), we changed msg->level from being a u16 to being an unsigned
> 3 bit bitfield.  That means we can remove the code here to handle log
> levels which are in the tens or hundreds column.

We should do that for the facility value, now that level is split up
in separate fields. I'll prepare a fix.

Thanks,
Kay
