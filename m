Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2GQWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:17:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:56014 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2GQWRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:17:20 -0400
Date: Tue, 17 Jul 2012 15:17:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Glauber Costa <glommer@parallels.com>
cc: "J. Bruce Fields" <bfields@fieldses.org>, Jonathan Corbet <corbet@lwn.net>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
In-Reply-To: <4FF6B32A.7070006@parallels.com>
Message-ID: <alpine.DEB.2.02.1207171512130.1373@asgard.lang.hm>
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net> <20120620195121.GA1719@fieldses.org> <4FF6B32A.7070006@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apologies for the late response

On Fri, 6 Jul 2012, Glauber Costa wrote:

> The same way we have checkpatch, we can have something automated that
> will attempt to rule out some trivial patches in the counting process.
> We can scan a patch, and easily determine if each part of it is:
>
> * pure whitespace
> * pure Documentation change
> * comment fix
>
> And if a patch is 100 % comprised by those, we simply don't count it.
> People that just want to increase their numbers - they will always
> exist, will tend to stop doing that. Simply because doing it will not
> help them at all.

I would look at things a bit differently.

strip out whitespace changes (they can be valuable, but usually only in 
combination with other work)

added comments or documetnation count double (we always need better 
documentation.

if the number of lines removed is more than a delata larger than the 
number added, the patch is probably a reorginization/cleanup and should 
get a boost in the metrics.

David Lang
