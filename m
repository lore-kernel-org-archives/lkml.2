Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0HWUJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:09:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55407 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0HWUJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L5H4dn18jMG4WKsGQpOZusTek9EKLgnAAlQqhyhbpQUXpHTOyWw9r2eyBCTh4eUD3X
         1mfejbLlErga6p4eLoRD3WdPnrSNa85Aw2AiOQo0E9pv3WshM5wCsJkZ+a3BieUptEPz
         NiopH4/P6eFL9gfMHDc9eJBaTPKR9HPspWJjw=
MIME-Version: 1.0
In-Reply-To: <20100823130109.6da43a58.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
	<20100823130109.6da43a58.akpm@linux-foundation.org>
Date: Mon, 23 Aug 2010 23:09:15 +0300
X-Google-Sender-Auth: XIPmK-h-FWEJfd0S0h1DcaSTBfQ
Message-ID: <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:01 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Hows about you add a helper function
>
>        void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
>
> then convert the callsites to use that, then nuke __GFP_NOFAIL?

I'd prefer killing off __GFP_NOFAIL properly :-)
