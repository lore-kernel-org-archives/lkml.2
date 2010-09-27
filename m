Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0I0SIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:08:46 -0400
Received: from claw.goop.org ([74.207.240.146]:41996 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759693Ab0I0SIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:08:45 -0400
Message-ID: <4CA0DDAB.9090507@goop.org>
Date: Mon, 27 Sep 2010 11:08:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kyle McMartin <kyle@redhat.com>,
        James Dingwall <james.dingwall@amdocs.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just	after
 the boot
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com> <20100927024044.GQ13116@bombadil.infradead.org> <20100927061336.GA22721@kroah.com>
In-Reply-To: <20100927061336.GA22721@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/26/2010 11:13 PM, Greg KH wrote:
> On Sun, Sep 26, 2010 at 10:40:44PM -0400, Kyle McMartin wrote:
>> On Thu, Sep 23, 2010 at 04:23:55PM +0100, James Dingwall wrote:
>>>> I was experiencing the same immediate crash with a null pointer
>>>> dereference (log below) on boot with 2.6.35.5.  Reverting
>>>> fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
>>>> me.
>>> Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.
>>>
>> Greg, a spelling mistake cropped into this patch during 2.6.35.5 that
>> James here points out. Adding you to CC since it seems to have missed
>> stable 2.6.35.6...
>>
>> Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.
> I don't understand, where did the error come from?  Was it in a patch I
> applied, or did I mess up some patch?  Is the same problem upstream, and
> if not, why not?

I don't know.  It looks like an 'x' was deleted due to an editor
fat-finger or something.  The original upstream patches were cc:d to
stable, so I think you would have got them that way (ie, I don't think I
sent them to you specifically).  Is there an opportunity in your
workflow where this error could have crept in?  The patches should have
been a pretty clean 'git cherry-pick' with no conflicts.

Thanks,
    J
