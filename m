Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2HOTxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62651 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2HOTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120815190328.GA6714@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <20120814230645.GA19607@quad.lixom.net> <20120815173711.GC14264@arm.com> <20120815190328.GA6714@quad.lixom.net>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 15 Aug 2012 20:53:12 +0100
X-Google-Sender-Auth: BA7IJLa38s_TG9ek0F_dIc61Oxw
Message-ID: <CAHkRjk4k0q9TuHqJMLtLy-wxFHN8xQEQERkpf2Qt_48+1Qwwgw@mail.gmail.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2012 20:03, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Aug 15, 2012 at 06:37:11PM +0100, Catalin Marinas wrote:
>> If we add machine_desc structure back, we could print which machine was
>> matched. But so far I try to keep the SoC code to a minimum and just do
>> the probing later in the SoC code (of_find_matching_node). Ideally we
>> shouldn't have any SoC code and just keep code in drivers but we'll see
>> how far we can get. We can discuss more details at the KS as I would
>> like the arm-soc team to get involved here.
>
> Interesting approach, I wonder if it'll scale, in particular if it comes
> to needing to do early setup and init. For device-level setup, generic
> will probably work just fine. And if it doesn't, things can be changed
> later. So it sounds like a good start.
>
> Definitely something we should discuss. I suggest not doing it at KS
> though, since only half of the arm-soc team is invited there. So the
> ARM mini-summit or hallway around LPC is a better venue.

I was indeed thinking of the ARM mini-summit or hallway discussions.
The KS has different topics and it wouldn't have been of wide interest
anyway.

-- 
Catalin
