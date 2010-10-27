Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0J0X6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:58:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51952 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab0J0X6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JeeQ3NMcgoEetxRwaDGwofcYBpJmZkcDLWj8IbaA8M0Zk7uHHuCHL9ON2UOi2KBmqE
         YcvQSDKaKLTRSt65rkZbBGc+Jv019CrfAy3aOvh92drwsf4GEm2FSpFzT2BSavYGoDyH
         2vXaSPAZbwTRwoE8ufCIsEnigblaAb+6SI55Y=
MIME-Version: 1.0
In-Reply-To: <4CC8B6E4.7070200@suse.cz>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <AANLkTimCoH1YA3sh3W_59QG42CwtRXQovgqUw2SndUO6@mail.gmail.com>
 <4CC8B6E4.7070200@suse.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 27 Oct 2010 19:58:29 -0400
Message-ID: <AANLkTinpD8NR-pBLfWV9uan-+MYddFQGtjMx0qhAG_n9@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Michal Marek <mmarek@suse.cz>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 19:33, Michal Marek wrote:
> On 28.10.2010 01:10, Mike Frysinger wrote:
>> On Wed, Oct 27, 2010 at 18:46, Michal Marek wrote:
>>> On 27.10.2010 20:23, Mike Frysinger wrote:
>>>> can we get this change dropped from linux-next until someone gets a
>>>> chance to fix it ?
>>>
>>> Sorry I missed this thread. So your last patch
>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
>>> failure? Can you submit it with a proper Signed-off-by and changelog?
>>
>> it shouldnt be a sep change.  it should be squashed into the broken
>> one so that the result works.
>
> The breakage already happened and I don't want to rewind the branch now.

if it isnt going to be merged until 2.6.38 merge window, i dont see
what the problem is with squashing a change into it.

> The worst that can happen is that if you bisect into ffe8018 you'll get
> a tree that does not build on Blackfin.

and h8300.  i thought there was another symbol prefix arch than just
these two, but my grep isnt showing it atm.

 The previous commit works and
> the next will do as well if you submit the patch.

if my change is going in after your bad commit, then you can squash it
with a simple `git commit --amend`.
-mike
