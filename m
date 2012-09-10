Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2IJRwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:52:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36689 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2IJRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:52:17 -0400
Message-ID: <504E28CE.6020103@wwwdotorg.org>
Date: Mon, 10 Sep 2012 11:52:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        lkml <linux-kernel@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Another tree for "next"
References: <m3obli3j7a.fsf@intrepid.localdomain> <20120910100144.dcbe2715cde0fea51345a354@canb.auug.org.au> <m31ui9g4ff.fsf@intrepid.localdomain>
In-Reply-To: <m31ui9g4ff.fsf@intrepid.localdomain>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 11:42 AM, Krzysztof Halasa wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
>>> could you please add the following to your "next" tree?
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git  branch: next
> 
>> Could you be a bit more clear about what will be in that tree, please?
>> Also when you repost this request, please post it a bit more widely among
>> other people/lists who may be interested in this work.  Remember that
>> linux-next is really only for stuff that is ready for Linus to pull into
>> the next merge window (or bug fixes).  Also, would this tree be pulled
>> directly by Linus, or via some other tree?
> 
> My plan is to merge all the stuff I'm (eventually) working on in the
> above tree. For now - mostly IXP4xx (ARM CPU etc.) stuff which goes to
> Linus

ARM-SoC-related pull requests should be sent to the arm-soc tree, who
will then aggregate all the ARM-SoC-related changes and issue pull
requests to Linus.

That is, arm@kernel.org, plus the Linux ARM kernel list CC'd.

The patches would also need to be sent to the Linux ARM kernel list (and
any other relevant lists) before being applied to your tree.

ARM core changes would likely go through Russell King's tree, perhaps
depending on what dependencies they have.
