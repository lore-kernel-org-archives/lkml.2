Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0G1Ffp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:35:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52503 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0G1Ffm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=teBJjXWI4KRegbvX/pgcwz3Y1iNDC7SrwFJeV8v3utXGqxOGN6xOdx6HAtuJoWk8DT
         unHZy3kzwp4AGdHXE7XSHjQ6vOEED+2UtTyCQpg5HkbLVNTx70OtLRTnk7uahja4iAd1
         FuVcVNV2utp32ochtzHae3/RxltQg4fpGfpmE=
MIME-Version: 1.0
In-Reply-To: <4C4FBE2B.6030606@monstr.eu>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu> 
	<1274863724-14906-2-git-send-email-monstr@monstr.eu> <1274884963.22648.245.camel@gandalf.stny.rr.com> 
	<20100526100805.171b3c48.akpm@linux-foundation.org> <4C4D4C2E.8010103@monstr.eu> 
	<20100727161819.cf6feab1.akpm@linux-foundation.org> <4C4FBE2B.6030606@monstr.eu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Jul 2010 01:35:20 -0400
Message-ID: <AANLkTimL92k-VnjXRqWsFTnqLcfYU=Ep3ScYLHQXVA9o@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead 
	local_irq_save/restore
To: monstr@monstr.eu
Cc: Andrew Morton <akpm@linux-foundation.org>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 01:20, Michal Simek wrote:
> Andrew Morton wrote:
>> On Mon, 26 Jul 2010 10:49:50 +0200 Michal Simek wrote:
>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>> hm, I wonder how my signoff got there.  Doesn't matter.
>
> http://lkml.org/lkml/2010/5/26/364

Sighed != Signed ;)
-mike
