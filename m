Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1LBCiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:38:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1LBCiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:38:54 -0500
Message-ID: <4ED83A31.5000401@redhat.com>
Date: Fri, 02 Dec 2011 10:38:41 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 44/62] ocfs2: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>	<1322371662-26166-45-git-send-email-amwang@redhat.com>	<20111201201846.GF1495@noexit.corp.google.com>	<4ED8322B.8010500@redhat.com> <20111201182934.b8dd4c27.akpm@linux-foundation.org>
In-Reply-To: <20111201182934.b8dd4c27.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月02日 10:29, Andrew Morton 写道:
> On Fri, 02 Dec 2011 10:04:27 +0800 Cong Wang<amwang@redhat.com>  wrote:
>
>> ___ 2011___12___02___ 04:18, Joel Becker ______:
>>> On Sun, Nov 27, 2011 at 01:27:24PM +0800, Cong Wang wrote:
>>>>
>>>> Signed-off-by: Cong Wang<amwang@redhat.com>
>>>
>>> Acked-by: Joel Becker<jlbec@evilplan.org>
>>>
>>> I'm presuming you'll handle pushing this with the entire series.
>>>
>>
>> Yeah, I hope either Andrew can take all of them
>
> waaay too many patches ;)
>
>> or this can be merged into trivial tree.
>
> I'd suggest you ask Stephen to add the git tree to -next.  Once it's
> all suitably reviewed/acked/etc, and we're in the merge window, ask
> Linus to pull it.
>

Great! I will do that.

Thanks for the hints.
