Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2DZPuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:50:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52239 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2DZPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120426142643.GA18863@alpha.arachsys.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com>
 <20120424082019.GA18395@alpha.arachsys.com> <65795E11DBF1E645A09CEC7EAEE94B9C014649EC4D@USINDEVS02.corp.hds.com>
 <20120426142643.GA18863@alpha.arachsys.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 26 Apr 2012 11:41:25 -0400
Message-ID: <CAHGf_=pcmFrWjfW3eQi_AiemQEm_e=gBZ24s+Hiythmd=J9EUQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
To: Richard Davies <richard.davies@elastichosts.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:26 AM, Richard Davies
<richard.davies@elastichosts.com> wrote:
> Satoru Moriya wrote:
>> > I have run into problems with heavy swapping with swappiness==0 and
>> > was pointed to this thread (
>> > http://marc.info/?l=linux-mm&m=133522782307215 )
>>
>> Did you test this patch with your workload?
>
> I haven't yet tested this patch. It takes a long time since these are
> production machines, and the bug itself takes several weeks of production
> use to really show up.
>
> Rik van Riel has pointed out a lot of VM tweaks that he put into 3.4:
> http://marc.info/?l=linux-mm&m=133536506926326
>
> My intention is to reboot half of our machines into plain 3.4 once it is
> out, and half onto 3.4 + your patch.
>
> Then we can compare behaviour.
>
> Will your patch apply cleanly on 3.4?

Note. This patch doesn't solve your issue. This patch mean,
when occuring very few swap io, it change to 0. But you said
you are seeing eager swap io. As Dave already pointed out, your
machine have buffer head issue.

So, this thread is pointless.
