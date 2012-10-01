Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2JAV7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:59:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58369 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2JAV7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:59:39 -0400
Date: Mon, 1 Oct 2012 23:59:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pierre Beck <mail@pierre-beck.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
Message-ID: <20121001215936.GC19126@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Pierre Beck <mail@pierre-beck.de>,
	linux-kernel@vger.kernel.org
References: <5068130A.4050602@pierre-beck.de>
 <506894D5.5060101@zytor.com>
 <506A06B6.50800@pierre-beck.de>
 <20121001215202.GB19126@liondog.tnic>
 <506A10E4.80905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <506A10E4.80905@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:53:40PM -0700, H. Peter Anvin wrote:
> It is very sad, though, that there are still drivers which don't work
> correctly in compat mode. Please report bugs on those -- that is just
> not acceptable.
>
> Unfortunately few distros provide 64-bit kernels for their 32-bit
> distros, which acerbates the problem.

Yes, the other way 'round, 32-bit userspace on 64-bit kernels should
work. And fixed if not.

Thanks.

-- 
Regards/Gruss,
    Boris.
