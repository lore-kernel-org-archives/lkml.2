Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2JESQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:16:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57240 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JESQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:16:13 -0400
Date: Fri, 5 Oct 2012 11:16:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mathieu.poirier@linaro.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
Message-ID: <20121005181608.GA24356@core.coreip.homeip.net>
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 11:59:29AM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> Andrew,
> 
> After requesting a number of changes that, to my understanding
> have been implemented, I have not been able to get the attention
> of the subsystem maintainer on this patch.
> 
> If there are still issues, I'm open to making changes but I want
> to make sure it doesn't get forgotten.  If there no objections,
> would you consider queuint it ?

Mathieu,

I have the same objection as before: using platform device solely for
the purpose of passing some data from board code to the driver. Surely
there are other ways of passing this bit of data... What about, for
example, making it an empty weak symbol so that board code could
override it with strong one?

Thanks.

-- 
Dmitry
