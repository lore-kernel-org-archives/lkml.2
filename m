Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1CNLMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:12:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36958 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1CNLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=X1WTgboRjfz1Q9mXVcsNp8ReMBhCzqfH8Rgdji8d/V+4od81+Ih64Ps2B51XhqD2U7
         kch0ORHX4sb3nQ/QqJfU2UqU3UzYrMcoBWNKqoDYQaEURL+0k9RvmFT1pFs2O4HsPOh4
         99diaq/NnrzRgWYa6KVooY4kFTcEk2juAnCLE=
MIME-Version: 1.0
In-Reply-To: <m3oc5eufrk.fsf@redhat.com>
References: <20110311165802.GA3508@intel.com>
	<4D7A64670200007800035F4C@vpn.id2.novell.com>
	<AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
	<4D7DE39302000078000362E6@vpn.id2.novell.com>
	<20110314095534.GB18058@elte.hu>
	<20110314104131.GG6275@bubble.grove.modra.org>
	<AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH__45869.1711457961$1300099861$gmane$org@mail.gmail.com>
	<m3oc5eufrk.fsf@redhat.com>
Date: Mon, 14 Mar 2011 13:12:15 +0200
X-Google-Sender-Auth: XshIkjFij7bRBrnkvyB_i7hDuAs
Message-ID: <AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Pekka Enberg <penberg@kernel.org>
To: Andreas Schwab <schwab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Modra <amodra@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Pekka Enberg <penberg@kernel.org> writes:
>> So what do you suggest that testers who want to, say, build old Linux
>> kernel versions with new binutils do?

On Mon, Mar 14, 2011 at 1:02 PM, Andreas Schwab <schwab@redhat.com> wrote:
> The same that testers have to do in order to build old Linux kernel
> versions with current versions of make.

Are you saying it's OK to screw over binutils users because GNU Make
did that too?

                       Pekka
