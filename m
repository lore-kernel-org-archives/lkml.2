Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143Ab1IOVnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:43:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935088Ab1IOVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:43:23 -0400
Date: Thu, 15 Sep 2011 16:43:08 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
Message-ID: <20110915214308.GA779@elie>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
 <1316117394-21666-8-git-send-email-andi@firstfloor.org>
 <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
 <4E726489.6080606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E726489.6080606@linux.intel.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 01:48:09PM -0700, Andi Kleen wrote:
> On 9/15/2011 1:45 PM, Josh Boyer wrote:
>> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:

>>> From: Andi Kleen<ak@linux.intel.com>
>>
>> What's the problem again?
>
> It's wrong. For more details see 0/*

Doesn't that mean that people using "git log", perhaps trying to debug
fallout from one of the patches (even if it's as small as making
context not match on some later patch), would have no idea what's
going on?  The cover letter says:

> This is a global tree sweep to fix up initconst section problems.
>
> Any variable const in initdata must be marked __initconst, not initdata.
> const __read_mostly is not allowed.
>
> Otherwise the global sections can get a read only marking and in some
> circumstances the compiler/and or the linker will detect conflicts.
>
> This patchkit aims to fix it up everywhere.

Which seems more sensible.  Since this is going through Linus's tree,
it might (or might not) make sense to combine the patches and describe
the effect once.
