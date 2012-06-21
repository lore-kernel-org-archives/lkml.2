Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2FUVck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:32:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2FUVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:32:39 -0400
Date: Thu, 21 Jun 2012 14:32:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, rni@google.com
Subject: Re: multi-second application stall in open()
Message-ID: <20120621213235.GF4642@google.com>
References: <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
 <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
 <20120621203615.GE4642@google.com>
 <CAKA=qzaFRubzvyjJQzgThRLsxLDc8NMdZy6WVZMFrF7ohsyjHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzaFRubzvyjJQzgThRLsxLDc8NMdZy6WVZMFrF7ohsyjHw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 21, 2012 at 04:28:24PM -0500, Josh Hunt wrote:
> When you say the code has diverged from upstream, do you mean from 3.0
> to 3.5?

It's based on something diverged from 2.6.X, so an ancient thing.

> Or maybe I'm misunderstanding what you're getting at. Also, if
> you have any links to the watchdog timer code you're referring to I
> would appreciate it.

Rakesh is the one who observed the bug and wrote the watchdog code.
Rakesh, I think Josh is seeing similar cfqq hang issue.  Did the
watchdog code reveal why that happened?  Or was it mainly to just kick
the queue and keep it going?

Thanks.

-- 
tejun
