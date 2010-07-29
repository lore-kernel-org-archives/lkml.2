Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0G2Kxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:53:30 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:53690 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0G2Kx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:53:29 -0400
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <201007231407.51605.helmut.schaa@googlemail.com>
Date: Thu, 29 Jul 2010 07:53:21 -0300
Cc: Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, jmorris@namei.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7842A755-42A7-4882-8726-45CADDB4E1E2@linux.vnet.ibm.com>
References: <201006091227.15729.helmut.schaa@googlemail.com> <5204AD54-F4BF-49A8-9168-3FCA112AAA2B@linux.vnet.ibm.com> <20100623130700.a032c373.akpm@linux-foundation.org> <201007231407.51605.helmut.schaa@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2010, at 9:07 AM, Helmut Schaa wrote:

> Hi,
> 
> Am Mittwoch 23 Juni 2010 schrieb Andrew Morton:
>> On Wed, 23 Jun 2010 16:55:54 -0300
>> Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
>> 
>>>> (top-posting repaired.  Please don't do that).
>>>> 
>>>> This wasn't a very good way to send a patch.  I edited the diff,
>>>> reconstructed the patch and then assembled a decent-looking changelog. 
>>>> I also changed your acked-by to the required signed-off-by, because you
>>>> were on the patch's delivery path.
>>>> 
>>>> Pretty please: next time, prepare a proper mergeable patch with the
>>>> correct attributions and signoffs?  Thanks.
>>> 
>>> Sure, sorry. I was just not certain if I could just resent Helmut's patch to LKML without messing with his authorship.
>> 
>> You can.  Put his "From:" line right at the top of the changelog and
>> everyone's patch-receiving tools will honour that.  If the From: at the
>> top of the changelog is absent, the tools will fall back to using the
>> From: line in the mail headers.
> 
> This patch still didn't make it into mainline and it fixes a regression.
> Rajiv, do you plan to resubmit the patch or did you expect it to go through
> Andrew's tree?
> 

Hi Helmut,

I expected it to make into Andrew's tree, since his recommendations were for the next time I submit a patch that matched the circumstances of this one, also, he mentioned he had to fix the issues by hand.

Andrew, do you want me to resubmit it? If so, I'm more than ok with that too though.

Thanks,
Rajiv


