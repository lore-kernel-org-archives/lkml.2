Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab1BZOpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 09:45:17 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36766 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1BZOpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 09:45:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Al4q1+WEeTI/8iiZYNQNx4hcjBb7TcV5jmMwsjAz/feeyyGmbVf5IOZ+C2BFakpRsx
         IEx/XaKKJlbxd8aouJOcRissyR6qvT1D/w07lVgbcivTubEzuMQeK88LidYVVBtKb4uP
         NqkQ49CtCRb0iL/nwG3t+jGoOuo1+RcTofpSU=
MIME-Version: 1.0
In-Reply-To: <20110224121339.GE23042@quack.suse.cz>
References: <1295402148.4773.143.camel@debian>
	<1295402606.1949.871.camel@sli10-conroe>
	<20110120151656.GC18875@redhat.com>
	<20110126081529.GA28909@sli10-conroe.sh.intel.com>
	<1297502512.29573.26.camel@debian>
	<AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
	<1297650318.29573.2482.camel@debian>
	<1297732201.24560.2.camel@sli10-conroe>
	<20110221164909.GG6584@quack.suse.cz>
	<1298449487.14712.1064.camel@debian>
	<20110224121339.GE23042@quack.suse.cz>
Date: Sat, 26 Feb 2011 15:45:12 +0100
Message-ID: <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>
Cc: "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 1:13 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 23-02-11 16:24:47, Alex,Shi wrote:
>> Though these patches can not totally recovered the problem, but they are
>> quite helpful with ccache enabled situation. It increase 10% performance
>> on 38-rc1 kernel.
>  OK and what was the original performance drop with WRITE_SYNC change?
>
>> I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here:
>> with patches:
>  I'm attaching patches rebased on top of latest Linus's tree.
> Corrado, could you possibly run your fsync-heavy tests so that we see
> whether there isn't negative impact of my patches on your fsync-heavy
> workload? Thanks.
The workload was actually Jeff's, and the stalls that my change tried
to mitigate showed up on his enterprise class storage. Adding him so
he can test it.

Corrado
>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
