Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0J1TwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:52:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50780 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab0J1Tv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yAOWR9NH4TDPGWAhaCyqYiGDlnu73/oeC6iTNdmYM5xP2zpKWrbZPXYkF0y5/YRa95
         MVzjUci4UztkmwL7k9BfImRUYVQOIPI2gtfLrWEDqd6qbeXE0wlS+R8K/T0ZFaF4N9+E
         qqC7CSpQiNx/RUjpOotfEWdn8KEGBZ3ySrT78=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=j3CAhHExdEPuV6WGkgegizBE7Eyu7BSYQrgE+@mail.gmail.com>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <AANLkTimCoH1YA3sh3W_59QG42CwtRXQovgqUw2SndUO6@mail.gmail.com>
 <4CC8B6E4.7070200@suse.cz> <AANLkTinpD8NR-pBLfWV9uan-+MYddFQGtjMx0qhAG_n9@mail.gmail.com>
 <4CC967CE.4020100@suse.cz> <AANLkTi=j3CAhHExdEPuV6WGkgegizBE7Eyu7BSYQrgE+@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 28 Oct 2010 15:51:35 -0400
Message-ID: <AANLkTimunQMdg2dOTond3sATujz+Mr8d4nO+7FNU15PF@mail.gmail.com>
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

On Thu, Oct 28, 2010 at 15:46, Mike Frysinger wrote:
> On Thu, Oct 28, 2010 at 08:08, Michal Marek wrote:
>> On 28.10.2010 01:58, Mike Frysinger wrote:
>>>  The previous commit works and
>>>> the next will do as well if you submit the patch.
>>>
>>> if my change is going in after your bad commit, then you can squash it
>>> with a simple `git commit --amend`.
>>
>> I know how to rewrite the branch, I just don't want to do it needlessly
>> so that 'git pull' still works for people tracking the branch.
>
> keeping git bisect sane is not what i would classify as "needlessly"

plus, there is no requirement that your current tree be what Linus
pulls.  add my patch to your branch-that-may-not-be-rebased, then
create a new branch with those two squashed, and have Linus pull that.
 your main branch will pick up a merge commit, but who cares.
-mike
