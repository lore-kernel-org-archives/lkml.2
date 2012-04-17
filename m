Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2DQJeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:34:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab2DQJeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:34:08 -0400
Message-ID: <4F8D391D.8080008@suse.de>
Date: Tue, 17 Apr 2012 11:34:21 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>  <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>  <4F6EEEC1.4030608@redhat.com>  <20120326213809.GA29788@bloggs.ozlabs.ibm.com>  <4F7191E8.7020804@redhat.com>  <20120330120107.GA28503@bloggs.ozlabs.ibm.com>  <4F784C4D.3000409@redhat.com> <1333314138.30734.17.camel@pasglop>  <4F796C18.2040209@redhat.com> <1333359979.30734.48.camel@pasglop>  <3BB9812B-6FE2-4370-9D55-D273364BFFD1@suse.de>  <4F8C1652.7000004@redhat.com> <1334617517.25353.17.camel@pasglop> <4F8D19D3.1060002@redhat.com>
In-Reply-To: <4F8D19D3.1060002@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 09:20 AM, Avi Kivity wrote:
> On 04/17/2012 02:05 AM, Benjamin Herrenschmidt wrote:
>> On Mon, 2012-04-16 at 15:53 +0300, Avi Kivity wrote:
>>> kvm.git next is exposed to linux-next, where they get tested quite a
>>> lot.  Granted it's mostly build testing, and people are unlikely to
>>> test
>>> kvm there, but they will test the non-kvm bits that creep in there.
>>>
>>>> The alternative would be that I don't have a -next tree, just
>>> collect patches and immediately send them to Avi. That way the main
>>> kvm tree would be broken more often, but at least we don't get these
>>> horrible synchronization latencies.
>>>
>>> That works too.  Don't post immediately; 2-3 week batches would reduce
>>> noise.
>> Or do like I do with Kumar for FSL stuff... his stuff gets pulled via my
>> tree but his tree is in linux-next as well. There's no reason not to do
>> that.
>>
>> That way, his next branch gets linux-next coverage whether it's in my
>> tree or not, and I pull when I put the final powerpc-next together,
>> which gives me a chance to do a quick vet "just in case" and sort out
>> any major conflict before it all goes to Linus.
>>
> Sure, that works too.

Sounds even easier to me. So how do I get my tree into linux-next?


Alex

