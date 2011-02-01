Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1BAMLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:11:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42348 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1BAMLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I/TGaTIKuRKFtUzGp9Rt/feXfNeO8MNkULatwyZH5UKFophPUdlDB3kTC9XUVGmE4E
         D43ce9W61dPrexgHuIVQUbXwwwi6wBd8d8Q0t2LjMXlY8GSeeq2kEgIzw+WpGGc0sQNS
         E7A3ddLtA2W/nP7rlxlXRuYQ6aduHkdCR4qFI=
MIME-Version: 1.0
In-Reply-To: <m24o8o7k6o.fsf@linux.intel.com>
References: <1295440968.2276.46.camel@dell>
	<ih8qf2$41t$3@dough.gmane.org>
	<4D380279.4070502@suse.cz>
	<1295594371.27658.3.camel@dell>
	<20110121101755.GP16804@shadowen.org>
	<1296461958.4168.5.camel@dell>
	<AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
	<20110131134252.GD16804@shadowen.org>
	<AANLkTim4r0J9WAm6dPT3-d7CXUtvKtmNe5hpyW=Tvgr0@mail.gmail.com>
	<m24o8o7k6o.fsf@linux.intel.com>
Date: Tue, 1 Feb 2011 14:11:35 +0200
Message-ID: <AANLkTi=64=wShhFbTK_Fdpwdnm3ryXK3VTrJCctGdB4J@mail.gmail.com>
Subject: Re: Checkpatch problem with Kconfig help symbol ?
From: Tomas Winkler <tomasw@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, tapio.vihuri@nokia.com,
        ext Michal Marek <mmarek@suse.cz>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 1:00 AM, Andi Kleen <ak@linux.intel.com> wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>>>
>>> Yeah that is a little better.  I do remind you that if the description
>>> is good enough shorter than 4 lines then you can ignore checkpatch.  It
>>> is a style guide not a style enforcer.  You are allowed to ignore things
>>> if you can justify it.
>>
>> Please consider patch I've posted
>> http://marc.info/?l=linux-kernel&m=129647530611677&w=2
>
> I originally didn't put in the number intentionally to make
> it harder to game it. Most likely for a whole driver
> or whole subsystems 4 lines are not enough to describe
> it properly.
>
> But yes if it's just for a debug feature you can ignore it.
> But then most likely your debug feature shouldn't be
> in Kconfig in the first place, but some runtime setting
>
> (rule of thumb: if it controls less than 1KB of code it's
> likely a bad idea in Kconfig)
>
> And more complex debug features that do actually carry
> significant code should have proper description.
>
> I think a better change would be to describe this
> more fully, not add the number.

These are all valid points but current message just leave you puzzled
and you have to look inside checkpatch.pl to figure out what it wants.
I'm not sure how would you lay your thoughts concisely  in one line
warning or script them into the script.

My guess would be that most of the developers  tends to come witch
checkpatch.pl clean and even when you expose the number 4 it still
make them stop and think how to fill them properly. Maybe you can
squeeze into the waring  pointer to CodyingStyle section.

Thanks
Tomas
