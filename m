Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1HEKzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:55:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59389 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HEKza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110805104356.GA13055@elte.hu>
References: <20110726154226.93A9F9D401C@zog.reactivated.net>
	<20110805104356.GA13055@elte.hu>
Date: Fri, 5 Aug 2011 11:55:29 +0100
X-Google-Sender-Auth: HzZfpr5vF3uQIXpVRD3ZGFxkNiw
Message-ID: <CAMLZHHQCcWwG6mg1LNHrZ5E4q0M=OHjhsQgPWgPqzC63u57yEw@mail.gmail.com>
Subject: Re: [PATCH] x86, olpc: Wait for last byte of EC command to be accepted
From: Daniel Drake <dsd@laptop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        dilinger@queued.net, pgf@laptop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 11:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
> What did that result in - a resume hang? (i.e. how urgent is this fix
> - v3.1 material or v3.2 material?)

Sorry - the explanation is indeed lacking in that area!

It means that sometimes, on XO-1.5 (but not XO-1), the devices that
were marked as wakeup sources can't wake up the system. e.g. you ask
for wifi wakeups, suspend, but then incoming wifi frames don't wake up
the system as they should.

In my opinion, as a simple bugfix (verified by 2 of our EC firmware
developers) it is 3.1 material.

Thanks,
Daniel
