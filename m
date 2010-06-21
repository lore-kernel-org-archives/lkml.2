Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab0FUVqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:46:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58472 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab0FUVqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xCoYWAkI5qI+pR+MIbaLeXl1+8twH5c3qGu18R0ExipGnjdqQRit7/2uYzV8R6BWP7
         Xwo/E0xUxiu92yu0it7701FPzi0VoDF77ePQRRzCUfM+kWF70PixGsdYR7dtk7c7Crcx
         OX0hF8DbnmlXcSVXZ8vKOyVWUnDy3JhwzBOFI=
MIME-Version: 1.0
In-Reply-To: <4C1FD78C.5030600@kernel.org>
References: <4C08FF36.80806@kernel.org>
	<4C0E9E03.1010508@kernel.org>
	<AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>
	<4C1FD1D0.4060803@kernel.org>
	<AANLkTil7QBQOsWIWQOGOaAz76eDqx9clZ1CfL2MR5484@mail.gmail.com>
	<4C1FD78C.5030600@kernel.org>
Date: Mon, 21 Jun 2010 14:46:27 -0700
X-Google-Sender-Auth: 1PyuSN1S7kC9upGuBaWoVLwO4fE
Message-ID: <AANLkTimw9yHxKuclHtZ4UzGtwzc2723IDLwmNguRhnZz@mail.gmail.com>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 
	configurations are updated during cpu on/offlining
From: Tony Luck <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 2:20 PM, Tejun Heo <tj@kernel.org> wrote:
> I'm primarily curious why different archs are doing things
> differently, which causes confusion and reduces test coverage.  Also,
> if you just think about the end result, what x86 is doing makes more
> sense.  Although it may end up with larger kernel image, it actually
> allows more to be dropped once init is complete.

It allows x86 to drop some code that it never needed in the first place.

i don't think that is better :-)

Maybe someone from x86-land can explain why they *keep* __exit
code as they are the ones doing it wrong (/me ducks, runs and hides)

-Tony
