Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1INIBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:01:40 -0400
Received: from mail.avalus.com ([89.16.176.221]:46857 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1INIBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:01:39 -0400
Date: Wed, 14 Sep 2011 09:01:34 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Linux Containers <containers@lists.osdl.org>,
        Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH] Fix repeatable Oops on container destroy with conntrack
Message-ID: <A51A04647674405AF6C39A4F@nimrod.local>
In-Reply-To: <20110914013500.GB17051@1984>
References: <2184C0CE5A5EDC94CDDA5053@Ximines.local>
 <20110912072524.GA2996@p183.telecom.by> <20110912093749.GE2194@1984>
 <E0902A9541FD5D118EA02B31@Ximines.local> <20110912183357.GC3641@1984>
 <87A32B21CA99D62CE1AB7A4B@Ximines.local>
 <7631498AC7E7C0EAD641AC7D@nimrod.local> <20110914013500.GB17051@1984>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 14 September 2011 03:35:00 +0200 Pablo Neira Ayuso 
<pablo@netfilter.org> wrote:

>> Is this new version OK? I am happy to adjust if not.
>
> Hm, I still think that this is a workaround.

It is a bit of a workaround, that is true. But it is a workaround
that will fix the bug in every kernel since 2.6.32 (and perhaps
before - I haven't looked). It's thus reasonably easily applicable
to stable kernel series.

I'm not clued-up enough on Netfilter to know what the right fix is,
but is applying the workaround in a commit which could be easily
backported, then applying the 'right fix' (assuming that is different)
a reasonable strategy?

As you can probably tell, my interest here is to get something that
doesn't oops into stable kernels.

-- 
Alex Bligh
