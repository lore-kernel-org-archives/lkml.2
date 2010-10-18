Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab0JRU1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab0JRU1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:27:41 -0400
Date: Mon, 18 Oct 2010 16:27:34 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/media/IR/imon.c: Use pr_err instead of err
Message-ID: <20101018202734.GA13401@redhat.com>
References: <1277018446.1548.66.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277018446.1548.66.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 07:20:46AM -0000, Joe Perches wrote:
> Use the standard error logging mechanisms.
> Add #define pr_fmt(fmt) KBUILD_MODNAME ":%s" fmt, __func__
> Remove __func__ from err calls, add '\n', rename to pr_err
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Since I haven't got around to actually looking into using dev_foo bits
instead where appropriate, lets just go ahead with this patch and if/when
I get around to it later, I can switch things to dev_foo where possible.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

