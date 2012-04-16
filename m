Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2DPNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:05:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2DPNFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:05:23 -0400
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F8C1652.7000004@redhat.com>
Date: Mon, 16 Apr 2012 15:05:21 +0200
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <71F69299-0CCB-4676-9EDA-7777E8F84E37@suse.de>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com> <4F6EEEC1.4030608@redhat.com> <20120326213809.GA29788@bloggs.ozlabs.ibm.com> <4F7191E8.7020804@redhat.com> <20120330120107.GA28503@bloggs.ozlabs.ibm.com> <4F784C4D.3000409@redhat.com> <1333314138.30734.17.camel@pasglop> <4F796C18.2040209@redhat.com> <1333359979.30734.48.camel@pasglop> <3BB9812B-6FE2-4370-9D55-D273364BFFD1@suse.de> <4F8C1652.7000004@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.04.2012, at 14:53, Avi Kivity wrote:

> On 04/16/2012 03:47 PM, Alexander Graf wrote:
>> On 02.04.2012, at 11:46, Benjamin Herrenschmidt wrote:
>> 
>>> On Mon, 2012-04-02 at 12:06 +0300, Avi Kivity wrote:
>>>>> The current process is such that it takes absolutely forever for our
>>>>> patches to get in, which is a major PITA for something in such state of
>>>>> active development.
>>>> 
>>>> If the patches were posted two weeks earlier, they would have gone in.
>>> 
>>> I believe on our side they were, but Alex took a while to make up his
>>> tree ... oh well..
>> 
>> Yes, because to me the kvm-ppc-next tree basically is the same semantically as -next for Avi. It's where patches cook a while to make sure they actually work. Nobody tests KVM PPC patches against kvm's master tree. All testing (compile and execution) happens against kvm-ppc-next.
>> 
>> That's why I don't see the point in having it cook again in Avi's tree. At the end of the day the patches will surely become way too chewy ;).
> 
> kvm.git next is exposed to linux-next, where they get tested quite a
> lot.  Granted it's mostly build testing, and people are unlikely to test
> kvm there, but they will test the non-kvm bits that creep in there.
> 
>> The alternative would be that I don't have a -next tree, just collect patches and immediately send them to Avi. That way the main kvm tree would be broken more often, but at least we don't get these horrible synchronization latencies.
> 
> That works too.  Don't post immediately; 2-3 week batches would reduce
> noise.

Ok, let's try to move to that scheme then :). I'll just send pull requests to you even though there are unprocessed other kvm ppc patches still around and we'll stage everything in your tree.


Alex

