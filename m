Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1FFUK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:10:59 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:36114 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1FFUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:10:58 -0400
Message-ID: <4DED344D.7000005@pandora.be>
Date: Mon, 06 Jun 2011 22:10:53 +0200
From: Bart De Schuymer <bdschuym@pandora.be>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Brad Campbell <brad@fnarfbargle.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <20110601011527.GN19505@random.random> <alpine.LSU.2.00.1105312120530.22808@sister.anvils> <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com> <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com> <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com> <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com> <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com> <isavsg$3or$1@dough.gmane.org> <4DE906C0.6060901@fnarfbargle.com>
In-Reply-To: <4DE906C0.6060901@fnarfbargle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 110606-1, 06/06/2011), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brad,

This has probably nothing to do with ebtables, so please rmmod in case 
it's loaded.
A few questions I didn't directly see an answer to in the threads I 
scanned...
I'm assuming you actually use the bridging firewall functionality. So, 
what iptables modules do you use? Can you reduce your iptables rules to 
a core that triggers the bug?
Or does it get triggered even with an empty set of firewall rules?
Are you using a stock .35 kernel or is it patched?
Is this something I can trigger on a poor guy's laptop or does it 
require specialized hardware (I'm catching up on qemu/kvm...)?

cheers,
Bart

PS: I'm not sure if we should keep CC-ing everybody, netfilter-devel 
together with kvm should probably do fine.

Op 3/06/2011 18:07, Brad Campbell schreef:
> On 03/06/11 23:50, Bernhard Held wrote:
>> Am 03.06.2011 15:38, schrieb Brad Campbell:
>>> On 02/06/11 07:03, CaT wrote:
>>>> On Wed, Jun 01, 2011 at 07:52:33PM +0800, Brad Campbell wrote:
>>>>> Unfortunately the only interface that is mentioned by name anywhere
>>>>> in my firewall is $DMZ (which is ppp0 and not part of any bridge).
>>>>>
>>>>> All of the nat/dnat and other horrible hacks are based on IP 
>>>>> addresses.
>>>>
>>>> Damn. Not referencing the bridge interfaces at all stopped our host 
>>>> from
>>>> going down in flames when we passed it a few packets. These are two
>>>> of the oopses we got from it. Whilst the kernel here is .35 we got the
>>>> same issue from a range of kernels. Seems related.
>>>
>>> Well, I tried sending an explanatory message to netdev, netfilter &
>>> cc'd to kvm,
>>> but it appears not to have made it to kvm or netfilter, and the cc to
>>> netdev has
>>> not elicited a response. My resend to netfilter seems to have dropped
>>> into the
>>> bit bucket also.
>> Just another reference 3.5 months ago:
>> http://www.spinics.net/lists/netfilter-devel/msg17239.html
>
> <waves hands around shouting "I have a reproducible test case for this 
> and don't mind patching and crashing the machine to get it fixed">
>
> Attempted to add netfilter-devel to the cc this time.
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


-- 
Bart De Schuymer
www.artinalgorithms.be

