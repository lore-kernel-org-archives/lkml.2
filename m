Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab1JGKXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:23:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61189 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641Ab1JGKXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:23:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=BFFKH8OHDY9Z+d4ojnb+cLiqCWIvrtRno76jlzXdX2XEhxwa27TEUZ/EW01LCtI7Z
	0B57JLsJNZT7qWv8rP3Bg==
MIME-Version: 1.0
In-Reply-To: <20111006152508.GI14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<20111006152508.GI14482@one.firstfloor.org>
Date: Fri, 7 Oct 2011 12:23:40 +0200
Message-ID: <CABPqkBTRDesV-0caMpWSnuYrSppfntUzt+NmPPdYUXdXsv+Ygg@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken branches
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 5:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Thanks very nice patchkit (at least from the description,
> haven't read it yet)

Thanks.

>
>> # Overhead  Source Symbol     Target Symbol
>> # ........  ................  ................
>>
>>     18.13%  [.] f1            [.] main
>>     18.10%  [.] main          [.] main
>>     18.01%  [.] main          [.] f1
>
> The big problem here is no line numbers (something I miss for other analysis
> too).  I hope that can be fixed so that analysis inside functions becomes
> possible. Something similar to pprofs line mode.
>
You get line numbers with annotate only today so this is not specific to this
particular patch. But yeah, it would be nice.
