Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423498Ab2LGRnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:43:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423351Ab2LGRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:43:48 -0500
Message-ID: <50C22AB0.8060405@canonical.com>
Date: Fri, 07 Dec 2012 12:43:12 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 17/27] Revert "sched, autogroup: Stop going ahead if autogroup
 is disabled"
References: <20121207005825.232489605@linuxfoundation.org> <20121207005830.838566702@linuxfoundation.org> <50C225D0.9030902@canonical.com> <20121207173117.GA18986@kroah.com>
In-Reply-To: <20121207173117.GA18986@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 12:31 PM, Greg Kroah-Hartman wrote:
> On Fri, Dec 07, 2012 at 12:22:24PM -0500, Joseph Salisbury wrote:
>> Will you also be including this patch in v3.5 stable?
> There is no v3.5-stable kernel tree anymore, it has been end-of-life for a while.
>
> There is a 3.5-stable tree that Canonical is doing, but no one on the
>   Cc: you sent this to is in control of that one.
>
> Sorry,
>
> greg k-h

Sorry about the typo, I meant to request v3.2-stable.

Thanks,

Joe
