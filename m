Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0JGTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:34:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:44248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0JGTen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:34:43 -0400
Message-ID: <4CAE1F47.3050105@kernel.org>
Date: Thu, 07 Oct 2010 21:28:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        just.for.lkml@googlemail.com, herbert@gondor.hengli.com.au,
        hch@infradead.org, neilb@suse.de, dm-devel@redhat.com
Subject: Re: Linux 2.6.36-rc7
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
In-Reply-To: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 19:33:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On 10/06/2010 11:45 PM, Linus Torvalds wrote:
> So I decided to break my a-week-is-eight-days rut, and actually
> release -rc7 after a proper seven-day week instead. Wo-oo!
> 
> And yes, that's probably as exciting as it gets, which is just fine by
> me. This should be the last -rc, I'm not seeing any reason to keep
> delaying a real release. There was still more changes to
> drivers/gpu/drm than I really would have hoped for, but they all look
> harmless and good. Famous last words.

I'm afraid there is a possibly workqueue related deadlock under high
memory pressure.  It happens on dm-crypt + md raid1 configuration.
I'm not yet sure whether this is caused by workqueue failing to kick
rescuers under memory pressure or the shared workqueue is making an
already existing problem more visible and in the process of setting up
an environment to reproduce the problem.

 http://thread.gmane.org/gmane.comp.file-systems.xfs.general/34922/focus=1044784

Thanks.

-- 
tejun
