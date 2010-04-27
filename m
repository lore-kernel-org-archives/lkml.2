Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0D0Lg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:36:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0D0Lg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:36:26 -0400
From: Thomas Renninger <trenn@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Tue, 27 Apr 2010 13:39:34 +0200
User-Agent: KMail/1.9.10
Cc: Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org> <201004231050.10667.trenn@suse.de> <20100423090819.4273b327@infradead.org>
In-Reply-To: <20100423090819.4273b327@infradead.org>
MIME-Version: 1.0
X-Length: 2333
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004271339.34711.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010 06:08:19 pm Arjan van de Ven wrote:
> On Fri, 23 Apr 2010 10:50:10 +0200
> Thomas Renninger <trenn@suse.de> wrote:
>  Especially on battery, users will appreciate some minutes
>
> > of more battery lifetime and do not care about some ms of IO
> > latencies.
>
> the assumption that power doesn't matter on AC is a huge fiction
> that any data center operator would love to get out of everyones head
> as quickly as possible.

Have I said power doesn't matter on AC?
Do you agree that a datacenter has different performance vs power 
tradeoff demands as a battery driven mobile device?

Back to the topic:
As you did not answer on my (several) sysfs knob request(s), I expect
you agree with it and will add one.

It's not only for real usage, but to give people a chance to easily
test and get feedback on different HW.

Thanks,

  Thomas
