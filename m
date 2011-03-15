Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1COHUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:20:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:39038 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1COHUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:20:53 -0400
Date: Tue, 15 Mar 2011 00:20:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Steven Rostedt <rostedt@goodmis.org>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
In-Reply-To: <20110312040941.GA15526@home.goodmis.org>
Message-ID: <alpine.DEB.2.00.1103150019060.5340@asgard.lang.hm>
References: <20110310.155556.48513201.davem@davemloft.net> <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com> <20110311204823.GB7906@fieldses.org> <20110311.130128.71121155.davem@davemloft.net> <1299878274.2814.8.camel@bwh-desktop>
 <20110311214209.GB9404@fieldses.org> <20110312040941.GA15526@home.goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Steven Rostedt wrote:

> On Fri, Mar 11, 2011 at 04:42:09PM -0500, J. Bruce Fields wrote:
>>
>> But assume you only did this in cases where the merge was trivial.
>> Would it be worth it, or would people be annoyed by the additional
>> branching?
>>
>
> I would be annoyed by it ;)
>
> It really is meaningless to do so, as all you are doing is documenting
> what commit caused this bug, and producing more problems by branching
> off of the broken commit. It wont matter till it is merged, but then if
> there are a lot of simple bug fixes, then you will have a lot of single
> merges of branches that fix those bugs.

what effect would this have on bisecting? if this helped people avoid 
bisecting in between the bad commit and the fix for it, it may be worth 
it.

David Lang

> It's just better to say in the change log of the fix:
>
> "commit abcdef1234 foo: add bar"
>
> Broke this, and this fixes it.
>
> Having the broken commit SHA1 and description in the change log is just
> as helpful as having the bug commit being its parent.
>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
