Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2CLTpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab2CLTpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:45:50 -0400
Message-ID: <4F5E526B.2020406@redhat.com>
Date: Mon, 12 Mar 2012 20:45:47 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E4757.705@redhat.com> <20120312190818.GA25523@host2.jankratochvil.net>
In-Reply-To: <20120312190818.GA25523@host2.jankratochvil.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 08:08 PM, Jan Kratochvil wrote:
> On Mon, 12 Mar 2012 19:58:31 +0100, Denys Vlasenko wrote:
>>       This is better, isn't it?
>>       Wouldn't it be nice if gdb would retrieve binary's name by itself?
>
> Yes, that yum should have been executed automatically, instead of just
> suggested by that:
> 	Try: yum --disablerepo='*' --enablerepo='*-debuginfo' install /usr/lib/debug/.build-id/ec/1fd70dbee0db36eff9527254d9d2bbfd260f13

My network is down. "yum install" won't work.


> But this is a user interface issue, it was discussed with PackageKit people
> etc. but it went nowhere.
>
> Sorry but I cannot code the whole OS myself including all the Gnome UI
> interfaces.
>
>>       (BTW: nothing prevents it from checking build ids and refusing
>>       to use it if they don't match.)
>
> And if they do not match it will need to run the yum command above anyway.
> So why to code two ways where the first one (by filename) works only sometimes
> while the second way works always?

My network is down. "yum install" won't work.


>> Does it follow from the above that filenames are *never* useful?
>
> They can be sometimes useful but they are superseded by build-ids; with
> build-ids they can be safely ignored.

I just gave you an example where filename is useful.
-- 
vda

