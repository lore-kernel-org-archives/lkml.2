Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab0KQLrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:47:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab0KQLrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:47:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gkyykrKk8rR+0JBu2UbHRwzSwdcCdon1JvsfRu4gnbXYQkP9iyCMZCCuqeGHrdt1db
         IZTwutVjXWGBdFEDNQVzYRLDHqYx1QSktm6622WtBCGL6DrNfAm7PEv4x6P5CQJ827x7
         9ip1rKiCztVqlx5M5IQaSssfLgwbDmezXRHms=
Message-ID: <4CE3C0DB.1050209@polymtl.ca>
Date: Wed, 17 Nov 2010 06:47:39 -0500
From: Benjamin Poirier <benjamin.poirier@polymtl.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andre@firstfloor.org,
        ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [ANNOUNCE] New tools: lttngtrace and lttngreport
References: <20101115134243.GA2772@Krystal> <20101115160745.GA7203@Krystal> <87y68sqiyb.fsf@basil.nowhere.org>
In-Reply-To: <87y68sqiyb.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/10 06:37 AM, Andi Kleen wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>>
>>         --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
>>         |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
>>         |    --- Woken up by an IRQ: IRQ 0 [timer]
>>         --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING
> 
> Very nice! Now how can we get that with an unpatched kernel tree?

Oh, that's easy: integrate LTTng!

> 
> -Andi
> 

