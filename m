Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab1D0TF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:05:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35188 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1D0TFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ToucBlj0LY/3ohmnTyAVV/OafCDByB9uD8AbiuCa+NrlldYoD95EFNlWJIq5qP6V9q
         9f2S5DiRChpza/LZFDbu7RceCvyinKrTvbavZY7M/4ELwNu/r9piB8j+kC71oS4868U6
         Zp+k+gYLUpJ5KJWlt9uBFuoPNPFOM9Wqgpndg=
MIME-Version: 1.0
In-Reply-To: <20110427162711.GA29460@elte.hu>
References: <20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<20110422165007.GA18401@vps.sharma-home.net>
	<20110422203022.GA20573@elte.hu>
	<20110423201409.GA20072@elte.hu>
	<20110424061645.GA12013@radium.snc4.facebook.com>
	<20110427111141.GB28993@elte.hu>
	<BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
	<20110427154805.GB23494@elte.hu>
	<20110427162711.GA29460@elte.hu>
Date: Wed, 27 Apr 2011 12:05:24 -0700
X-Google-Sender-Auth: 8PAo8P7BwgbH2jutGBJlHKMQCCQ
Message-ID: <BANLkTinA_PN_8nGDz_4SJcVZbagPndca+Q@mail.gmail.com>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
From: Arun Sharma <arun@sharma-home.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 9:27 AM, Ingo Molnar <mingo@elte.hu> wrote:

>
> That way we get a 'hidden overhead' profile: a profile of frequently executed
> code which executes in the CPU in a suboptimal way.
>
> So we should probably offer both events.
>

Yes - certainly.

 -Arun
