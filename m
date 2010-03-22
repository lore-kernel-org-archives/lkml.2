Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0CVQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0CVQQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:16:27 -0400
Message-ID: <4BA797C9.2030703@redhat.com>
Date: Mon, 22 Mar 2010 18:16:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com>
In-Reply-To: <4BA796DF.7090005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 06:12 PM, Avi Kivity wrote:
>> There were a few responses to that but none really addressed those 
>> problems -
>> they mostly tried to re-define the problem and suggested that i was 
>> wrong to
>> want such capabilities and suggested various inferior approaches 
>> instead. See
>> the thread for the details - i think i covered every technical 
>> suggestion that
>> was made.
>
>
> You simply kept ignoring me when I said that if something can be kept 
> out of the kernel without impacting performance, it should be.  I 
> don't want emergency patches closing some security hole or oops in a 
> kernel symbol server.

Or rather, explained how I am a wicked microkernelist.  The herring were 
out in force today.

-- 
error compiling committee.c: too many arguments to function

