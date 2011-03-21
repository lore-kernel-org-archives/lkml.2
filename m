Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1CUSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:17:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47940 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1CUSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k6rFW/j8ARbYX0qKbM9oLZ4OaP9TRCvoe5ebY77jpcITIvxZ3o/WBf/0qdDvRetPJp
         Aes9+gRqKdH2GNsKncjhXqD6j+wiPQVqlnQuGf9OCcmcGSOOuZMiG08klvrJFJ5ABepn
         dKuZ3QqGTexAdAkgsVSM7D8F0s2FYw7IBbDg0=
Message-ID: <4D8795A8.4060909@gmail.com>
Date: Mon, 21 Mar 2011 21:15:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com> <20110321170832.GC12718@sgi.com>
In-Reply-To: <20110321170832.GC12718@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 08:08 PM, Jack Steiner wrote:
...
> 
> We use KDB internally, and yes, it has the same issue. The version of the
> patch that uses KDB OR's the "handled" status for both KDB & the UV NMI handler.
> If either KDB or the UV NMI handler returns "handled", the code in traps.c exits
> after the call to the first die notifier.
> 
> Not particularily pretty but I could not find a better way to do it.
> 
> --- jack

  Btw Jack, I somehow missed (sorry) this patch only handles UV NMI handler so
for KGDB case you need some other patch on top?

-- 
    Cyrill
