Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1BYAwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:52:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:32202 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab1BYAwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:52:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,221,1297065600"; 
   d="scan'208";a="606336656"
Message-ID: <4D66FB76.7040701@intel.com>
Date: Fri, 25 Feb 2011 08:44:38 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: "Li, Shaohua" <shaohua.li@intel.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
References: <1295402148.4773.143.camel@debian> <1295402606.1949.871.camel@sli10-conroe> <20110120151656.GC18875@redhat.com> <20110126081529.GA28909@sli10-conroe.sh.intel.com> <1297502512.29573.26.camel@debian> <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com> <1297650318.29573.2482.camel@debian> <1297732201.24560.2.camel@sli10-conroe> <20110221164909.GG6584@quack.suse.cz> <1298449487.14712.1064.camel@debian> <20110224121339.GE23042@quack.suse.cz>
In-Reply-To: <20110224121339.GE23042@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Wed 23-02-11 16:24:47, Alex,Shi wrote:
>   
>> Though these patches can not totally recovered the problem, but they are
>> quite helpful with ccache enabled situation. It increase 10% performance
>> on 38-rc1 kernel. 
>>     
>   OK and what was the original performance drop with WRITE_SYNC change?
>   
The original drop is 30%.
>   
>> I have tried to enabled they to latest rc6 kernel but failed. the vmstat output is here: 
>> with patches:
>>     
>   I'm attaching patches rebased on top of latest Linus's tree. 
> Corrado, could you possibly run your fsync-heavy tests so that we see
> whether there isn't negative impact of my patches on your fsync-heavy
> workload? Thanks.
>
> 								Honza
>   

