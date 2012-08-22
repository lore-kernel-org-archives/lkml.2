Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2HVCvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:51:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2HVCu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:50:57 -0400
Date: Tue, 21 Aug 2012 19:48:29 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jovi Zhang <bookjovi@gmail.com>, tony.luck@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: add missed platform_device_unregister
Message-ID: <20120822024829.GA20787@lizard>
References: <CACV3sbKA6pjcjc+Wr-w+JNtzJfrJS=6tcMKgDzWMaZ_AV1NQ3A@mail.gmail.com>
 <20120821013958.GA27381@lizard>
 <CAGXu5j+KvkQV94D+kT4b5+UcCX1wZz_04STb3H4CmB1Em-fB3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+KvkQV94D+kT4b5+UcCX1wZz_04STb3H4CmB1Em-fB3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:19:15AM -0700, Kees Cook wrote:
[...]
> >>  static void __exit ramoops_exit(void)
> >>  {
> >>       platform_driver_unregister(&ramoops_driver);
> >> +     platform_device_unregister(dummy);
> >>       kfree(dummy_data);
> >>  }
> >>  module_exit(ramoops_exit);
> >
> > It looks OK to me. Unless there are objections I'll apply it to
> > linux-pstore.git.
> 
> Yup, looks right.
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied, thanks!
