Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1AaXAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:00:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:11363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1AaXAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:00:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,406,1291622400"; 
   d="scan'208";a="702567863"
From: Andi Kleen <ak@linux.intel.com>
To: Andy Whitcroft <apw@canonical.com>, Tomas Winkler <tomasw@gmail.com>
Cc: tapio.vihuri@nokia.com, ext Michal Marek <mmarek@suse.cz>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch problem with Kconfig help symbol ?
References: <1295440968.2276.46.camel@dell> <ih8qf2$41t$3@dough.gmane.org>
	<4D380279.4070502@suse.cz> <1295594371.27658.3.camel@dell>
	<20110121101755.GP16804@shadowen.org> <1296461958.4168.5.camel@dell>
	<AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
	<20110131134252.GD16804@shadowen.org>
	<AANLkTim4r0J9WAm6dPT3-d7CXUtvKtmNe5hpyW=Tvgr0@mail.gmail.com>
Date: Mon, 31 Jan 2011 15:00:31 -0800
In-Reply-To: <AANLkTim4r0J9WAm6dPT3-d7CXUtvKtmNe5hpyW=Tvgr0@mail.gmail.com>
	(Tomas Winkler's message of "Mon, 31 Jan 2011 21:08:02 +0200")
Message-ID: <m24o8o7k6o.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler <tomasw@gmail.com> writes:

>>
>> Yeah that is a little better.  I do remind you that if the description
>> is good enough shorter than 4 lines then you can ignore checkpatch.  It
>> is a style guide not a style enforcer.  You are allowed to ignore things
>> if you can justify it.
>
> Please consider patch I've posted
> http://marc.info/?l=linux-kernel&m=129647530611677&w=2

I originally didn't put in the number intentionally to make
it harder to game it. Most likely for a whole driver
or whole subsystems 4 lines are not enough to describe
it properly. 

But yes if it's just for a debug feature you can ignore it.
But then most likely your debug feature shouldn't be 
in Kconfig in the first place, but some runtime setting

(rule of thumb: if it controls less than 1KB of code it's 
likely a bad idea in Kconfig) 

And more complex debug features that do actually carry
significant code should have proper description.

I think a better change would be to describe this
more fully, not add the number.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
