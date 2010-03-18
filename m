Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0CRQ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0CRQ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:57:07 -0400
Message-ID: <4BA25ADC.7040504@redhat.com>
Date: Thu, 18 Mar 2010 18:54:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA23E61.4080003@codemonkey.ws> <20100318161310.GA447@elte.hu>
In-Reply-To: <20100318161310.GA447@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 06:13 PM, Ingo Molnar wrote:
> Currently there's a wall between kernel developers and user-space developers,
> and there's somewhat of an element of fear and arrogance on both sides. For
> efficient technology such walls needs torn down and people need a bit more
> experience with each other's areas.
>    


I think you're increasing the height of that wall by arguing that a 
userspace project cannot be successful because it's development process 
sucks and the only way to fix it is to put it into the kernel where 
people know so much better.  Instead we kernel developers should listen 
to requirements from users, even if their code isn't in tools/.

-- 
error compiling committee.c: too many arguments to function

