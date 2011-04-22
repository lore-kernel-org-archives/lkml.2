Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1DVJYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:24:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47129 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1DVJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F6qXP08H0ucLpZ9wy1SGFNL/LfjeJ1I8llvqA9vL4cZNJ5cAuEGuzfa7EdJ7tcqctD
         EGbkX1ScwjMUCND6xLE/f/l7CcSWXXVQnz5s+Dk9GtS1ndEiEI7ik7E87wRVG/cgrL2/
         wG6o7BC2fkjYY6nXcZ42A+tIQ81xUu5vIaFRI=
MIME-Version: 1.0
In-Reply-To: <1303462476.2035.215.camel@laptop>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
	<1303398203-2918-5-git-send-email-dzickus@redhat.com>
	<20110422081838.GA24011@elte.hu>
	<BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
	<1303462476.2035.215.camel@laptop>
Date: Fri, 22 Apr 2011 13:24:44 +0400
Message-ID: <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:54 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-04-22 at 12:43 +0400, Cyrill Gorcunov wrote:
>> we need a different event and counters for watchdog.
>>
> Does it count the same thing though? If so we could look at having
> alternative encodings support (we might need something like that for
> offcore too).
>

Yes, they count the same thing (well some tech details are different but
not much).By using different counters we are allowed to run them
simultaneously which makes perf top works again.

Could you elaborate what you have in mind with "alternative encodings"
here?
