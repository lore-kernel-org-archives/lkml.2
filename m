Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1IGTeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:34:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1IGTem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:34:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=K+KufFdyYzX9FNduK1kPoguTASwF3wyT4rjEozam4fMBScKseNiEe/9p+khn7vYYq
	+DMgjOiQeFG4FI+uBt3dw==
MIME-Version: 1.0
In-Reply-To: <1315423726.11101.27.camel@twins>
References: <20110906204637.GA31826@quad>
	<1315383151.11101.13.camel@twins>
	<CABPqkBRzA32PW2E_wZrESrCQB2KPJqqomZD0M3x4ZBDzWJGi+Q@mail.gmail.com>
	<1315423726.11101.27.camel@twins>
Date: Wed, 7 Sep 2011 21:34:38 +0200
Message-ID: <CABPqkBRW3kXAkrHxZpBXg=UPD3y4b6U2_dKC_yWNfuABj+=B5g@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        dsahern@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 9:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-09-07 at 14:55 +0200, Stephane Eranian wrote:
>> On Wed, Sep 7, 2011 at 10:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2011-09-06 at 22:46 +0200, Stephane Eranian wrote:
>> >> +static const char *topo_fmt[] = {
>> >> +       "/sys/devices/system/cpu/cpu%d/topology/core_siblings_list",
>> >> +       "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list",
>> >> +       NULL
>> >> +};
>> >
>> > No nodes?
>> >
>> To record what information? core/thread siblings or memory stuff?
>
> Dunno really,.. but nodes are part of the topology and with people
> interested in all this uncore business it might make sense to have that.
> Maybe even record the node-distance table so you can reconstruct the
> interconnect topology.
>
>
I posted v4 which captures the numa topology (meminfo, cpulist). When you
combine with what I already had, you get the complete picture.
>
