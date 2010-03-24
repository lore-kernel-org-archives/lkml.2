Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0CXQs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:48:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab0CXQsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:48:25 -0400
Message-ID: <4BAA424C.5010306@redhat.com>
Date: Wed, 24 Mar 2010 18:48:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100324150137.GE14800@8bytes.org> <20100324152653.GA12225@redhat.com> <20100324153746.GF14800@8bytes.org> <4BAA3323.9000405@redhat.com> <20100324155041.GH14800@8bytes.org> <4BAA3556.2040802@redhat.com> <20100324161711.GJ14800@8bytes.org> <4BAA3BD6.8030401@redhat.com> <20100324163119.GL14800@8bytes.org> <4BAA3EB3.2070101@redhat.com> <20100324164500.GN14800@8bytes.org>
In-Reply-To: <20100324164500.GN14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:45 PM, Joerg Roedel wrote:
>
>> That's just what I want to do.  Leave it in userspace and then they can
>> deal with it without telling us about it.
>>      
> They can't do that with a directory in /proc?
>
>    

I don't know.

-- 
error compiling committee.c: too many arguments to function

