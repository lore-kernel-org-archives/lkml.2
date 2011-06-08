Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1FHL57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:57:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39502 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1FHL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MT87nHPge9/q5tNyB+UA8NGPxLbu3YeGmCOiFaKwXUJHsKtiYjVCuT6HQRXOyggNLH
         /bKZHZmMcfeXRZhWf1HO+BZt+HunMTH2c8P8/ARtcVXWzJGqtZ4+zZDvjXZfTqvjGmBS
         CGK/Uq1QHk46qd1PKNl3lOlbHI5V/7R6vBuT4=
MIME-Version: 1.0
In-Reply-To: <20110608083750.GH27166@one.firstfloor.org>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
	<20110608081957.GA14966@elte.hu>
	<20110608083750.GH27166@one.firstfloor.org>
Date: Wed, 8 Jun 2011 14:57:57 +0300
X-Google-Sender-Auth: z0G1cqduru90oWXy5SY5ffy7_dc
Message-ID: <BANLkTimZ65o-gRf8n3SRzTedd=fTCB55QQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: Readd asmregparm
From: Pekka Enberg <penberg@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Jun 8, 2011 at 11:37 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> That's a totally useless changelog (you are deliberately hiding
>> information again) so the series is obviously not acceptable.
>> Please fix and resend.
>
> I reread it and it seems complete to me. Please be more specific.
>
> If you refer to the followon patchkit - it's not ready for posting
> yet. However I believe these changes are reasonable cleanups that are useful
> on their own. That's why I posted them now.

So from my point of view, none of the changelogs explain why the
changes needed. Now, I'm not an expert on the x86 code so maybe I'm
missing something obvious but to me the only rationale seems to be
that you need it some unspecified follow-up patchkit. HTH.

                         Pekka
