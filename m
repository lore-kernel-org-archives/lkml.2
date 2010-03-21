Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0CUUSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:18:38 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:51969 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752887Ab0CUUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:18:37 -0400
Message-ID: <4BA67F12.6030501@nagafix.co.uk>
Date: Mon, 22 Mar 2010 03:18:26 +0700
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
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com>
In-Reply-To: <4BA67D75.8060809@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 03:11 AM, Avi Kivity wrote:
> On 03/21/2010 10:08 PM, Olivier Galibert wrote:
>> On Sun, Mar 21, 2010 at 10:01:51PM +0200, Avi Kivity wrote:
>>> On 03/21/2010 09:17 PM, Ingo Molnar wrote:
>>>> Adding any new daemon to an existing guest is a deployment and 
>>>> usability
>>>> nightmare.
>>>>
>>> The logical conclusion of that is that everything should be built into
>>> the kernel.  Where a failure brings the system down or worse.  Where 
>>> you
>>> have to bear the memory footprint whether you ever use the 
>>> functionality
>>> or not.  Where to update the functionality you need to deploy a new
>>> kernel (possibly introducing unrelated bugs) and reboot.
>>>
>>> If userspace daemons are such a deployment and usability nightmare,
>>> maybe we should fix that instead.
>> Which userspace?  Deploying *anything* in the guest can be a
>> nightmare, including paravirt drivers if you don't have a natively
>> supported in the OS virtual hardware backoff.
>
> That includes the guest kernel.  If you can deploy a new kernel in the 
> guest, presumably you can deploy a userspace package.
That's not always true.
The host admin can control the guest kernel via "kvm -kernel" easily 
enough, but he may or may not have access to the disk that is used in 
the guest. (think encrypted disks, service agreements, etc)

Antoine
>> Deploying things in the
>> host OTOH is business as usual.
>
> True.
>
>> And you're smart enough to know that.
>
> Thanks.
>

