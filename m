Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0CRSKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:10:52 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:57888 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab0CRSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:50 -0400
Message-ID: <4BA26CA2.6000505@codemonkey.ws>
Date: Thu, 18 Mar 2010 13:10:42 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jes Sorensen <Jes.Sorensen@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E7E2.3010803@redhat.com> <20100318095418.GD2157@elte.hu> <4BA2030B.3090007@redhat.com> <20100318105826.GA2174@elte.hu> <4BA2296A.90401@redhat.com> <20100318142255.GG25642@elte.hu> <4BA23CA5.20801@redhat.com> <20100318165435.GA9756@elte.hu>
In-Reply-To: <20100318165435.GA9756@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:54 AM, Ingo Molnar wrote:
> I took a quick look at the qemu.git log and more than half of all recent
> contributions came from Linux distributors.
>    

I don't know what you're looking at, but in the past month, there's been 
56 unique contributors, with 411 changesets.  I count 16 people employed 
by distributions with 188 changesets.

> So without KVM Qemu would be a much, much smaller project. It would be similar
> to how it was 5 years ago.
>    

I'm not saying that KVM isn't significant.  I'm employed to work on QEMU 
because of KVM.

I'm just saying that KVM users aren't 99% of the community and that we 
can't neglect the rest of the community.

Regards,

Anthony Liguori
