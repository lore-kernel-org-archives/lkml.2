Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0FMPfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:35:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48895 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0FMPff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBoSNKgPW62BOFeugOfn2TQgZI4D7I6hXS/nc7tESh7MF/2Rqf24ZQ7y4GMtC89L+8
         scLsmYvkkJ76sUgz6Caku/+9imH/aubOI9F44gvQZCL9xWuIWlJvHeHSflsvv1OlSO00
         71t3Upve/ioru0WWlPFLx+LDJqg4MIDqYtGIA=
MIME-Version: 1.0
In-Reply-To: <YPGdyfWGvNK.A.KHH.75OFMB@chimera>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.KHH.75OFMB@chimera>
Date: Sun, 13 Jun 2010 11:35:34 -0400
Message-ID: <AANLkTikKQBrH6rvsj-6chzYqd8NUsmEQBGD2jvTvpJVf@mail.gmail.com>
Subject: Re: [Bug #16054] UML broken for CONFIG_SLAB
From: Parag Warudkar <parag.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 10:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16054
> Subject         : UML broken for CONFIG_SLAB
> Submitter       : Parag Warudkar <parag.lkml@gmail.com>
> Date            : 2010-05-23 21:40 (22 days old)
> Message-ID      : <alpine.DEB.2.00.1005231149100.605@parag-laptop>
> References      : http://marc.info/?l=linux-kernel&m=127465083806617&w=2

Borislav,

I believe both of the issues I encountered that are part of this bug
entry (missing/superfluous slab inclusion issues and cfq related boot
crash due to popcnt/hweight stuff) have a known fix [1] but I am not
sure if any of it actually landed in -git. Quick search through
git.kernel.org log doesn't show anything relevant.

I think there was ongoing discussion on the hweight include fix - so
keeping this open until fixes are in may be what we should do as of
now.


[1] http://marc.info/?l=linux-kernel&m=127522065202435&w=2


Thanks.

Parag
