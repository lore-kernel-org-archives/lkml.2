Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0C2NQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:16:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19207 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0C2NQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:16:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=MQWMzEChuhTZLgiv3hGnXvuKQseLeNUC5jQcvq8WLT5nQRqF4HDe01QiVZ3WPE8L9
	WDEuQdVhBMthIQMSQLyMg==
MIME-Version: 1.0
In-Reply-To: <87bpe7qnrg.fsf@basil.nowhere.org>
References: <20100329122021.765109681@chello.nl>
	 <87bpe7qnrg.fsf@basil.nowhere.org>
Date: Mon, 29 Mar 2010 14:16:23 +0100
Message-ID: <bd4cb8901003290616s67aac7d3jb4bec31e2c0a73d4@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf: Use LBR for machine/oops debugging
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 2:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
>> The LBRs are relatively cheap to keep enabled and provide some history
>> to OOPSen, also some CPUs are reported to keep them over soft-reset,
>> which allows us to use them to debug things like tripple faults.
>>
>> Therefore introduce a boot option: lbr_debug=on, which always enable
>> the LBRs and will print the LBRs on CPU init and die().
>
>
> die is too late. they will only contain the oops code then.
>
Most likely yes,  especially with small LBR, such as on Intel Core.


> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
