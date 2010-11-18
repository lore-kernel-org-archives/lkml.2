Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0KRJTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:19:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29131 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0KRJTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:19:40 -0500
Message-ID: <4CE4EE21.6050305@parallels.com>
Date: Thu, 18 Nov 2010 12:13:05 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Linux Containers <containers@lists.osdl.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu> <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu> <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org> <20101117153902.GA1155@hallyn.com> <4CE3F8D1.10003@kernel.org>
In-Reply-To: <4CE3F8D1.10003@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 06:46 PM, Tejun Heo wrote:
> Hello, Serge.
> 
> On 11/17/2010 04:39 PM, Serge E. Hallyn wrote:
>>> I'm sorry but in-kernel CR already looks like a major misdesign to me.
>>
>> By this do you mean the very idea of having CR support in the kernel?
>> Or our design of it in the kernel?
> 
> The former, I'm afraid.

Can you elaborate on this please?

>> Let's go back to July 2008, at the containers mini-summit, where it
>> was unanimously agreed upon that the kernel was the right place
>> (Checkpoint/Resetart [CR] under
>> http://wiki.openvz.org/Containers/Mini-summit_2008_notes ), and that
>> we would start by supporting a single task with no resources.  Was
>> that whole discussion effectively misguided, in your opinion?  Or do
>> you feel that since the first steps outlined in that discussion
>> we've either "gone too far" or strayed in the subsequent design?
> 
> The conclusion doesn't seem like such a good idea, well, at least to
> me for what it's worth.  Conclusions at summits don't carry decisive
> weight.  It'll still have to prove its worthiness for mainline all the
> same and in light of already working userland alternative and the
> expanded area now covered by virtualization, the arguments in this
> thread don't seem too strong.
> 
> Thanks.
> 

