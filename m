Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1LNQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:19:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53645 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111214144722.GA10791@somewhere.redhat.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com> <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
 <20111213192556.GD2421@somewhere.redhat.com> <20111214081809.GJ25232@elte.hu> <20111214144722.GA10791@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 14 Dec 2011 08:19:16 -0800
Message-ID: <CAL26m8JBPq67WD9HY4W8qKkvj0hKDBOfuxmRQVF12E8=NFBgwg@mail.gmail.com>
Subject: Re: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 6:47 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Dec 14, 2011 at 09:18:09AM +0100, Ingo Molnar wrote:
>> Didn't Thomas critique them - if so then were those observations
>> addressed?
>>
>> Thanks,
>>
>>       Ingo
>
>
> Ah right. Vaibhav any news about that?

Yes, the patches were dropped from -mm because of a merge conflict
with another patch. I am planning to resend the patch after rebasing
to the latest tip.

Thomas did critique them and I dropped a part of the patch. He didn't
comment on other parts, which I guess he didn't see any issues.



Vaibhav Nagarnaik
