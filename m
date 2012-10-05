Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2JEMnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:43:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60250 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab2JEMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:43:17 -0400
Date: Fri, 5 Oct 2012 14:43:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [RFC] perf: perf_event_attr anon unions and static initializer
 issue
Message-ID: <20121005124350.GA12944@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stephane Eranian <eranian@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <CABPqkBRCjd5=9t1URNXQvu8GbAHMjf3ixKtb6BV7ebBTZDLF1A@mail.gmail.com>
 <1349434879.14388.35.camel@twins>
 <CABPqkBTjwEp+wO_PW6xtazYiZXA-ogsmKVOd2-JJgbh47sHcQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBTjwEp+wO_PW6xtazYiZXA-ogsmKVOd2-JJgbh47sHcQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 01:49:44PM +0200, Stephane Eranian wrote:
> Yeah, unfortunately. I ended up creating a separate table for config1
> and initializing attr.config1 at runtime. That way it works regardless
> of the compiler....

Did the same thing in the persistent events patches recently:

http://marc.info/?l=linux-kernel&m=134513917126309

-- 
Regards/Gruss,
Boris.
