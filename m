Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab0ENRs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:48:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37153 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0ENRs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G93R5sFfzhvolvzY1p4N2z/EVjtTFp+kXbnWsJv+/Y1nXYpsYKfx8IVBnyxPSiuTMR
         nSKeFZ2yZGMxaOnnMdC/+SdAlS2vms2u6JrCXSdIeiMTm6Xo3D2ydN3rETON+OhjNQju
         6MAOyAlglfIOcDsrO/XwSov7ycnMe6WTNdKds=
MIME-Version: 1.0
In-Reply-To: <20100514164057.GC13509@lenovo>
References: <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
	 <1273834571.3530.82.camel@minggr.sh.intel.com>
	 <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo>
	 <20100514145213.GA13509@lenovo>
	 <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
	 <20100514162813.GB13509@lenovo>
	 <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
	 <20100514164057.GC13509@lenovo>
Date: Fri, 14 May 2010 23:18:52 +0530
Message-ID: <AANLkTinQL16caUSZnFFr4gs_vfT93mwkNTK7I_eShZvA@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Fri, May 14, 2010 at 10:10 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, May 14, 2010 at 10:06:44PM +0530, Jaswinder Singh Rajput wrote:
> ...
>> >
>> > Thanks Jaswinder,
>> >
>> > it means counters management somehow screwed at moment (it was working before).
>> > I'm working on it.
>> >
>>
>> Ok, I added few more events and now I am able see few hardware events :
>>
> ...
> Thanks, but I need to figure out where they hide in first place. Will keep
> you in touch.
>

Earlier I given the command 'ls' which was very small only 601636
instructions so branches
and branch-misses came up with <not counted>

When I given a bigger command 'ls -lR /dev' with 10159428
instructions, so I get branches and branch-misses count.

Thanks,
--
Jaswinder Singh.
