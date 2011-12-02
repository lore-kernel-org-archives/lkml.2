Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1LBT3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:29:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51754 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1LBT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:29:02 -0500
Date: Fri, 2 Dec 2011 23:28:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat
Message-ID: <20111202192857.GM14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.756761754@openvz.org>
 <20111129200627.GO5169@outflux.net>
 <20111202002405.GA7701@p183.telecom.by>
 <20111202072800.GC14515@moon>
 <CAGXu5jLSuvFnV5er6A5abg6EMWM6XVZmVaOCRjwTMS+p4oEXAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLSuvFnV5er6A5abg6EMWM6XVZmVaOCRjwTMS+p4oEXAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 11:23:32AM -0800, Kees Cook wrote:
> >
> > I perhaps miss some history here, you mean just print 0
> > instead of 1, right?
> 
> The history is that when "0" is seen for start_code, tools like "ps"
> assumed the process was a kernel thread, so "1" was used as a hack to
> not break userspace reporting. So yeah, since this is a new field,
> it's fine to just do:
> 
> +         (mm && permitted) ? mm->start_data : 0,
> +         (mm && permitted) ? mm->end_data : 0,
> +         (mm && permitted) ? mm->start_brk : 0,
> 

Yup, thanks a lot Kees, I'll update.

	Cyrill
