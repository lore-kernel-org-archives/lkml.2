Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1CQBw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:52:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35102 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1CQBwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:52:50 -0400
Message-ID: <4D81696C.9020805@canonical.com>
Date: Wed, 16 Mar 2011 18:52:44 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Kees Cook <kees.cook@canonical.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/3] security: Yama LSM
References: <1300237742-23415-1-git-send-email-kees.cook@canonical.com> <20110316013527.GQ5466@outflux.net> <4D80F59D.6000603@canonical.com> <alpine.LRH.2.00.1103171120590.31128@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1103171120590.31128@tundra.namei.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2011 05:52 PM, James Morris wrote:
> On Wed, 16 Mar 2011, John Johansen wrote:
> 
>> On 03/15/2011 06:35 PM, Kees Cook wrote:
>>> On Tue, Mar 15, 2011 at 06:08:59PM -0700, Kees Cook wrote:
>>>> This is an update of the Yama Linux Security Module.
>>>>
>>>> Now that there are attempts at permitting multiple active LSM modules,
>>>> Yama should be reconsidered.
>>>
>> Well not just that multiple active LSM modules are being reconsidered, but
>> that YAMA is now being picked and used by a couple of other distros.
> 
> Distros should not be shipping out of tree code and then using that as a 
> reason to ask for it to be merged.
> 
that wasn't actually my intent (though I will admit it kind of appears that
way), I was merely trying to say others are finding it useful.  That the YAMA
enhacements should be reconsidered, whether that be in the current form or
another.  I actually quite liked Casey's suggestion of splitting the controls

> We've obviously not reached a consensus on how to approach these security 
> enhancements, so be aware that the final outcome upstream may not follow 
> the approach that distros have already taken.
> 
true enough and distros who choose to ship something before upstream takes
it will have to deal with any breakage or incompatibilities.

> My preference is to see core security functionality incorporated into the 
> core kernel where possible.
> 
> The purpose of LSM is to allow the configuration of different enhanced 
> access control schemes (i.e. beyond Unix DAC).  Ad-hoc security 
> enhancements which are not part of a coherent & distinct access control 
> scheme should not be dropped into LSM simply because LSM has hooks in the 
> right places, has security in the name, or because core developers pushed 
> back on the code elsewhere.
>
Hrrmm, well I expect I have a slightly different take on this from both an
LSM and core dev pov.

> Personally, I'd like to see the kernel offer as much hardening as possible 
> for the general case, but this kind of work especially needs to be 
> incorporated with full buy-in from core developers.

Well I will agree that it needs to be hashed out again, and then maybe even
again and the best possible implementation needs to be settled on :)

I'm not arguing that YAMA needs to be taken in its current, just that it
implements features I would really like to see upstream.
