Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0CVSG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0CVSG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:06:57 -0400
Message-ID: <4BA7B1AE.6050500@redhat.com>
Date: Mon, 22 Mar 2010 20:06:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 	project
References: <20100321205531.GC30194@elte.hu> <20100322111411.GC3483@elte.hu>	 <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu>	 <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu>	 <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu>	 <4BA796DF.7090005@redhat.com> <4BA797C9.2030703@redhat.com> <84144f021003220940x25e40624pb0b86f62b79fd707@mail.gmail.com>
In-Reply-To: <84144f021003220940x25e40624pb0b86f62b79fd707@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 06:40 PM, Pekka Enberg wrote:
> On Mon, Mar 22, 2010 at 6:16 PM, Avi Kivity<avi@redhat.com>  wrote:
>    
>>> You simply kept ignoring me when I said that if something can be kept out
>>> of the kernel without impacting performance, it should be.  I don't want
>>> emergency patches closing some security hole or oops in a kernel symbol
>>> server.
>>>        
>> Or rather, explained how I am a wicked microkernelist.  The herring were out
>> in force today.
>>      
> Well, if it's not being a "wicked microkernelist" then what is it?
>    

I know I'm bad.

> Performance is hardly the only motivation to put things into the
> kernel. Think kernel mode-setting and devtmpfs (with the ironic twist
> of original devfs being removed from the kernel) here, for example.
>    

Motivations include privileged device access, needing to access physical 
memory, security, and keeping the userspace interface sane.  There are 
others.  I don't think any of them hold here.

-- 
error compiling committee.c: too many arguments to function

