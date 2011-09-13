Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1IMVA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:00:56 -0400
Received: from claw.goop.org ([74.207.240.146]:35703 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1IMVAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:00:53 -0400
Message-ID: <4E6FC481.6040505@goop.org>
Date: Tue, 13 Sep 2011 14:00:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au> <4E5690C3.2050706@goop.org> <4E5693DD.2010307@zytor.com> <20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au> <4E56D6E1.6030405@zytor.com> <20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au> <20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au> <alpine.LFD.2.02.1109131706410.2723@ionos> <4E6FC2D3.2060408@goop.org> <alpine.LFD.2.02.1109132254470.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109132254470.2723@ionos>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 01:56 PM, Thomas Gleixner wrote:
> On Tue, 13 Sep 2011, Jeremy Fitzhardinge wrote:
>
>> On 09/13/2011 08:07 AM, Thomas Gleixner wrote:
>>> On Tue, 13 Sep 2011, Stephen Rothwell wrote:
>>>> Hi,
>>>>
>>>> On Fri, 26 Aug 2011 12:54:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>> On Thu, 25 Aug 2011 16:12:33 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>>>> On 08/25/2011 04:06 PM, Stephen Rothwell wrote:
>>>>>>>> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
>>>>>>>> should be dropped.
>>>>>>> That's a bit tricky as I get a rolled up tip tree.  The best I could do
>>>>>>> is revert the commit that merges the x86/spinlocks branch into
>>>>>>> auto-latest ...  I'll do that for today (unless something happens to the
>>>>>>> tip tree in the next hour).
>>>>>>>
>>>>>> OK, let me bother Ingo about it.
>>>>> For today, I have done "git revert -m 1 6f8fa39c81f1" after merging the
>>>>> tip tree.
>>>> I am still doing this in each linux-next, and it doesn't appear to have
>>>> been fixed up the the tree on tesla.tglx.de, yet, I think.
>>> We'll take it out. 
>> Actually, the tip x86/spinlocks was the most up-to-date version of those
>> patches (since hpa had rebased them to a more recent version of mainline).
> Mooo. You tell that after we did a nasty rebase from hell :(

I'd been meaning to take it out of my tree to solve Stephen's problem,
but, well, kernel.org.

    J
