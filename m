Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2F1Bev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:34:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52843 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2F1Bet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:34:49 -0400
X-AuditID: 9c930179-b7cceae000004195-bb-4febb4b2bba6
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jovi Zhang <bookjovi@gmail.com>, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
	<87fw9hyvt5.fsf@sejong.aot.lge.com>
	<20120627161557.GA3878@infradead.org>
	<20120627190725.GA1380@krava.redhat.com>
	<1340827102.10063.72.camel@twins> <20120627201928.GA1008@krava>
Date: Thu, 28 Jun 2012 10:30:51 +0900
In-Reply-To: <20120627201928.GA1008@krava> (Jiri Olsa's message of "Wed, 27
	Jun 2012 22:19:28 +0200")
Message-ID: <877gusz0hg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 22:19:28 +0200, Jiri Olsa wrote:
> On Wed, Jun 27, 2012 at 09:58:22PM +0200, Peter Zijlstra wrote:
>> On Wed, 2012-06-27 at 21:07 +0200, Jiri Olsa wrote:
>> > -modifier_bp    [rwx]
>> > +modifier_bp    [rwx]{1,3}
>> > 
>> > and fail parse_breakpoint_type function for nonsense types
>> 
>> If you're going to modify parse_breakpoint_type() to fail on nonsense
>> types, you might as well do the + thing, right?
>> 
>> Doesn't really matter that much though ;-)
>
> yo ;-)

So, are you ok to resend the original patch with your ack? Or will you
send the above soon?

Thanks,
Namhyung
