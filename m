Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0JTJdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:33:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0JTJde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IsQ11nmipk7rJsIvo7A9Hom5nMbgFe/3s/Vtp6xqcGIBH0anMxAyD3drG3NwfBQ2p9
         FC0amuh73AEtyavhWNPFfNS0rqAc16q5R6FU9Tt9EkvydDWZUlxy7J9sb62Dpv7y70jG
         9r88HAt1b7eP4C2euTtTlnb1BBne0etvw3fxQ=
Message-ID: <4CBEB767.7030404@suse.cz>
Date: Wed, 20 Oct 2010 11:33:27 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: + softirq-cleanup-preempt-check.patch added to -mm tree
References: <201010051905.o95J5BrS013873@imap1.linux-foundation.org>	 <20101005193833.GA16493@elte.hu>  <4CAB92E9.7060509@suse.cz> <1286640927.1891.13.camel@laptop>
In-Reply-To: <1286640927.1891.13.camel@laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2010 06:15 PM, Peter Zijlstra wrote:
> But I agree the line should be split, I however much prefer the form:
> 
> static inline
> void softirq_preempt_check(struct softirq_action *h, int prev_count)

Ok I can do that while I'm ratelimiting the message. When this error
occurs, it floods the kmsg quite a lot for works like netif_rx.

thanks,
-- 
js
suse labs
