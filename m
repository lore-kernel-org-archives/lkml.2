Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1E3Bg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:36:26 -0400
Received: from ozlabs.org ([203.10.76.45]:50959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1E3BgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:36:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Moriya <satoru.moriya@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH][BUGFIX] param: fix return value handling in param_set_*
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3FF808C5@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3FF808C5@USINDEVS02.corp.hds.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sun, 29 May 2011 15:03:26 +0930
Message-ID: <87fwnyjck9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 19:38:04 -0400, Satoru Moriya <satoru.moriya@hds.com> wrote:
> In STANDARD_PARAM_DEF, param_set_* handles the case in which strtolfn
> returns -EINVAL but it may return -ERANGE. If it returns -ERANGE,
> param_set_* may set uninitialized value to the paramerter. We should handle
> both cases.
> 
> The one of the cases in which strtolfn() returns -ERANGE is following:
> 
>  *Type of module parameter is long
>  *Set the parameter more than LONG_MAX
> 
> Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>

Thanks, applied.

Cheers,
Rusty.
