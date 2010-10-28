Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0J1TrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:47:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56215 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0J1TrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DVtSTVIvGOQXJUlW2ldFuPTZMsRLjI5diq59ZqF7URL0vrStB7iYTzYrjCcB0Ky5bz
         Wqh09w3DNkstHnEfP095QFSYvDUJWe+8s9/vdCNkoCUIzU7l9BTPDkhwuXLURVLwuMkA
         igGY11Pfwpxo7yP5qh9qsAQuuC7UmWGGXDdl8=
MIME-Version: 1.0
In-Reply-To: <4CC967CE.4020100@suse.cz>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <AANLkTimCoH1YA3sh3W_59QG42CwtRXQovgqUw2SndUO6@mail.gmail.com>
 <4CC8B6E4.7070200@suse.cz> <AANLkTinpD8NR-pBLfWV9uan-+MYddFQGtjMx0qhAG_n9@mail.gmail.com>
 <4CC967CE.4020100@suse.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 28 Oct 2010 15:46:47 -0400
Message-ID: <AANLkTi=j3CAhHExdEPuV6WGkgegizBE7Eyu7BSYQrgE+@mail.gmail.com>
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

On Thu, Oct 28, 2010 at 08:08, Michal Marek wrote:
> On 28.10.2010 01:58, Mike Frysinger wrote:
>> On Wed, Oct 27, 2010 at 19:33, Michal Marek wrote:
>>> On 28.10.2010 01:10, Mike Frysinger wrote:
>>>> On Wed, Oct 27, 2010 at 18:46, Michal Marek wrote:
>>>>> Sorry I missed this thread. So your last patch
>>>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
>>>>> failure? Can you submit it with a proper Signed-off-by and changelog?
>>>>
>>>> it shouldnt be a sep change.  it should be squashed into the broken
>>>> one so that the result works.
>>>
>>> The breakage already happened and I don't want to rewind the branch now.
>>
>> if it isnt going to be merged until 2.6.38 merge window, i dont see
>> what the problem is with squashing a change into it.
>
> kbuild-2.6.git#kbuild has stuff meant for 2.6.37, In fact I'll be
> sending a pull request to Linus today. It would be great to sort the
> Blackfin & h8300 build failure first, though.

so you sent a pull request to Linus knowing full well that the
contents of your merge will completely break two architectures ?

>>  The previous commit works and
>>> the next will do as well if you submit the patch.
>>
>> if my change is going in after your bad commit, then you can squash it
>> with a simple `git commit --amend`.
>
> I know how to rewrite the branch, I just don't want to do it needlessly
> so that 'git pull' still works for people tracking the branch.

keeping git bisect sane is not what i would classify as "needlessly"

at any rate, i'm leaving now for vacation and wont be back for like
two weeks.  feel free to take any of the changes i posted earlier
under whatever authorship/sob you want.
-mike
