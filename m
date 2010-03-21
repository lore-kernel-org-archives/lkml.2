Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0CUUcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:32:01 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:49791 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752739Ab0CUUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:31:59 -0400
Message-ID: <4BA68234.1060804@nagafix.co.uk>
Date: Mon, 22 Mar 2010 03:31:48 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Olivier Galibert <galibert@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com>
In-Reply-To: <4BA68063.2050800@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 03:24 AM, Avi Kivity wrote:
> On 03/21/2010 10:18 PM, Antoine Martin wrote:
>>> That includes the guest kernel.  If you can deploy a new kernel in 
>>> the guest, presumably you can deploy a userspace package.
>>
>> That's not always true.
>> The host admin can control the guest kernel via "kvm -kernel" easily 
>> enough, but he may or may not have access to the disk that is used in 
>> the guest. (think encrypted disks, service agreements, etc)
>
> There is a matching -initrd argument that you can use to launch a daemon.
I thought this discussion was about making it easy to deploy... and 
generating a custom initrd isn't easy by any means, and it requires 
access to the guest filesystem (and its mkinitrd tools).
>   I believe that -kernel use will be rare, though.  It's a lot easier 
> to keep everything in one filesystem.
Well, for what it's worth, I rarely ever use anything else. My virtual 
disks are raw so I can loop mount them easily, and I can also switch my 
guest kernels from outside... without ever needing to mount those disks.

