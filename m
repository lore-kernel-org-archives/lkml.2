Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DOLtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:49:20 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:63417 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0DOLtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OL4Wp9Xejk9r+5ckuIXS/GHywHZrxdyV0kTHciTuCelxSjTiNRiK8FVd55QAb1PeBe
         R07LdETiJNuVStBFXzsCwfc7EfRewFkZQz+Z0ky/VEdRATIg1in8BJxDKMyQiXsLe46C
         CIuP43AwsWcCxPDz4ZBoKL1Khir5RsYVsGesY=
MIME-Version: 1.0
In-Reply-To: <4BC6FBC8.9090204@kernel.org>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
	 <4BC6CB30.7030308@kernel.org>
	 <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>
	 <4BC6E581.1000604@kernel.org>
	 <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
	 <4BC6FBC8.9090204@kernel.org>
Date: Thu, 15 Apr 2010 20:49:17 +0900
Message-ID: <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 8:43 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/15/2010 07:21 PM, Minchan Kim wrote:
>> kill alloc_pages_exact_node?
>> Sorry but I can't understand your point.
>> I don't want to kill user of alloc_pages_exact_node.
>> That's opposite.
>> I want to kill user of alloc_pages_node and change it with
>> alloc_pages_any_node or alloc_pages_exact_node. :)
>
> I see, so...
>
>  alloc_pages()          -> alloc_pages_any_node()
>  alloc_pages_node()     -> alloc_pages_exact_node()
>
> right?  It just seems strange to me and different from usual naming
> convention - ie. something which doesn't care about nodes usually
> doesn't carry _node postfix.  Anyways, no big deal, those names just
> felt a bit strange to me.

I don't want to remove alloc_pages for UMA system.
#define alloc_pages alloc_page_sexact_node

What I want to remove is just alloc_pages_node. :)
Sorry for confusing you.

-- 
Kind regards,
Minchan Kim
