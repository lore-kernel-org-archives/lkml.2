Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1ISBPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 21:15:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48626 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1ISBPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 21:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110918.210344.570661374586887894.davem@davemloft.net>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
 <4E76864D.4080907@ll.mit.edu> <20110918.210344.570661374586887894.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Sep 2011 18:14:53 -0700
X-Google-Sender-Auth: l_0wxHMdt2IrmQ7_zdoQxMSIZ_A
Message-ID: <CA+55aFyENEpGJmTq55=n0_gDiF6RQmdKw-ts4AdQAFQJ1TkF-Q@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>, Jeremy Kerr <jk@ozlabs.org>
Cc: david.ward@ll.mit.edu, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. I *think* the right person for patchwork issues is Jeremy Kerr,
but I migth be wrong..

Jeremy, the fact that apparently patchworks loses proper names is a
killer feature - but very much in the wrong meaning of "killer". Any
way to make sure that doesn't happen?

                    Linus

On Sun, Sep 18, 2011 at 6:03 PM, David Miller <davem@davemloft.net> wrote:
> From: David Ward <david.ward@ll.mit.edu>
> Date: Sun, 18 Sep 2011 20:01:17 -0400
>
>> On 09/18/2011 02:06 PM, Linus Torvalds wrote:
>>> 2011/9/17 David Miller<davem@davemloft.net>:
>>>> dpward (2):
>>>>       net: Make flow cache namespace-aware
>>>>       net: Handle different key sizes between address families in flow cache
>>>>
>>>> nhorman (1):
>>>>       net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
>>>>
>>>> rajan.aggarwal85@gmail.com (1):
>>>>       net/can/af_can.c: Change del_timer to del_timer_sync
>>> Guys, if somebody has such a broken email setup that they don't even
>>> show their own name, don't take patches from them.
>>
>> At least in my case, that is Patchwork's fault.  My name only started
>> showing up like that in commits after I registered for an account
>> (http://patchwork.ozlabs.org/register/), and I don't see any way to
>> change the way my name appears in the Patchwork profile options.
>>
>> The emails I sent to the netdev list showed my full name; see:
>> http://marc.info/?l=linux-netdev&m=131527867326729&w=2
>> http://marc.info/?l=linux-netdev&m=131527879226819&w=2
>
> I hope some mechanism can be created to undo this behavior.
>
