Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab2IFUPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:15:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44530 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2IFUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:15:43 -0400
Date: Thu, 6 Sep 2012 13:15:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Emil Goode <emilgoode@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: picoLCD: Remove use of deprecated function
Message-ID: <20120906201538.GK29092@google.com>
References: <1346942780-8091-1-git-send-email-emilgoode@gmail.com>
 <20120906221252.1402ba50@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120906221252.1402ba50@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:12:52PM +0200, Bruno Prémont wrote:
> On Thu, 06 September 2012 Emil Goode <emilgoode@gmail.com> wrote:
> > The flush_delayed_work_sync function is deprecated,
> > we can instead call flush_delayed_work directly.
> > 
> > Sparse is giving a warning:
> > drivers/hid/hid-picolcd_fb.c:611:2: warning:
> > 	‘flush_delayed_work_sync’ is deprecated
> > 	(declared at include/linux/workqueue.h:454)
> > 	[-Wdeprecated-declarations]
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> 
> Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
> 
> This matches a patch by Tejun a few weeks ago which was partially
> skipped in -next due to merge conflict with code split in picoLCD.
> 
> See http://comments.gmane.org/gmane.linux.kernel.next/23740
> 
> For the sake of proper bisectability, this should go in after
> Tejun's workqueue changes (if needed at all depending on how merge
> happens during pull by Linus).

Yeah, we either can ask Linus to fix it up during merge or send a
separate patch afterwards.  In this case, I don't think it matters too
much either way.  I tend to send out pull request fairly early in the
merge window, I'll try to remember to poke Linus about the merge
conflict.

Thanks.

-- 
tejun
