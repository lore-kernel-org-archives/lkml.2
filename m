Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab0G0EkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:40:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49543 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0G0EkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gkurQgQZ0ahZqLy4U/UuCGAyVRTuDwRCNeG6cgu73ZWd9cquq1dlkjnHULKQDDYMEf
         /+NjVh0zOQxsNFDSMwSg3OKIxaFhVQokyQ7wGniOJM4OmmQjttfWmnbZLuTZ1cDjy+C9
         btv2zNBhJmKSPF/jTVEMJGCqKaowdQ6wy1ruY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007261510320.2993@chino.kir.corp.google.com>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> 
	<AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com> 
	<AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com> 
	<alpine.LSU.2.00.1005211410170.14789@sister.anvils> <AANLkTil8sEzrsC9If5HdU8S5R-sK84_fUt_BXUDcAu0J@mail.gmail.com> 
	<alpine.DEB.2.00.1006011351400.13136@chino.kir.corp.google.com> 
	<AANLkTikUO+WMHXqTMc7jR84UMgKidzX5d5JX6q=DvmpY@mail.gmail.com> 
	<alpine.DEB.2.00.1007261510320.2993@chino.kir.corp.google.com>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 27 Jul 2010 14:39:48 +1000
Message-ID: <AANLkTi=Aswf+Hp+qfsC2sCo32hU3E2D4zt3-R35BZ=MC@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2010 08:12, David Rientjes <rientjes@google.com> wrote:
> On Tue, 27 Jul 2010, dave b wrote:
>
>> Actually it turns out on 2.6.34.1 I can trigger this issue. What it
>> really is, is that linux doesn't invoke the oom killer when it should
>> and kill something off. This is *really* annoying.
>>
>
> I'm not exactly sure what you're referring to, it's been two months and
> you're using a new kernel and now you're saying that the oom killer isn't
> being utilized when the original problem statement was that it was killing
> things inappropriately?

Sorry about the timespan :(
Well actually it is the same issue. Originally the oom killer wasn't
being invoked and now the problem is still it isn't invoked - it
doesn't come and kill things - my desktop just sits :)
I have since replaced the hard disk - which I thought could be the
issue. I am thinking that because I have shared graphics not using KMS
- with intel graphics - this may be the root of the cause.

--
All things that are, are with more spirit chased than enjoyed.		--
Shakespeare, "Merchant of Venice"
