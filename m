Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2ECFt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:49:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38677 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2ECFt4 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 3 May 2012 01:49:56 -0400
Message-ID: <4FA21C66.1030009@suse.com>
Date: Thu, 03 May 2012 11:19:26 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>, linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
References: <20120427081815.4478.26011.stgit@perseus.themaw.net> <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com> <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com> <4FA11E59.9050004@suse.com> <20120502135044.6d815e62@tlielax.poochiereds.net>
In-Reply-To: <20120502135044.6d815e62@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 11:20 PM, Jeff Layton wrote:
> On Wed, 02 May 2012 17:15:29 +0530
> Suresh Jayaraman <sjayaraman@suse.com> wrote:
> 
>> On 04/28/2012 09:03 AM, Steve French wrote:
>>> The fix makes sense, but it is fairly recent and I haven't had a
>>> chance to try it,
>>> so unless a new release is imminent, I would prefer to put in the next merge
>>> request (I have at least one more fix likely as well) next week.
>>
>> We need this fix for -stable as well, right? Please include
>>
>>    Cc: stable@vger.kernel.org
> 
> The stable-kernel-rules.txt file says this:
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 

Doh, looks like I had assumed (wrongly) that this fixes the problem
reported here

   http://marc.info/?l=linux-cifs&m=133460168320472&w=2

(mapping to a dfsroot and cd to a reflink returning "Object is remote"
or "Not a directory" error). I didn't have a setup to verify it too.

I notice that Steve has already merged this patch adding Cc to stable
and the Cc has to be removed before sending the pull request.


Suresh
