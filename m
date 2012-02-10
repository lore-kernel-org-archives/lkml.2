Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab2BJPpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:45:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab2BJPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:45:37 -0500
Date: Fri, 10 Feb 2012 10:44:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, seiji.aguchi@hds.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120210154453.GA3150@redhat.com>
References: <1328886693-20670-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328886693-20670-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:11:33AM -0500, Matthew Garrett wrote:

[..]
>  static int have_callable_console(void)
>  {
> @@ -1732,6 +1735,9 @@ void kmsg_dump(enum kmsg_dump_reason reason)
>  	unsigned long l1, l2;
>  	unsigned long flags;
>  
> +	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
> +		return;
> +

reason > KMSG_DUMP_OOPS?

Thanks
Vivek
