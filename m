Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0C3N0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:26:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34098 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0C3N0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DtL0w4n25sIeAuofRQdnzOpupM4YXlTKE554BrJCV0EnIE77PnJgekRR6cEP/7PUvE
         /H6Z81U+AQJHLX5nKBxfuLer6PzE7JgD17DzNlC9O5hsQHJ7cotKe3/9wop9Qhcg65NL
         anNIcYMqNrFZQ21GqoPRZO84WpZCd/rVqBac8=
Message-ID: <4BB1FCAF.6080409@gmail.com>
Date: Tue, 30 Mar 2010 22:29:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 14/17] input: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>	<1269885165-18617-15-git-send-email-tj@kernel.org> <20100330142148.2ac3fc0e.sfr@canb.auug.org.au> <4BB1EBD4.9030707@kernel.org>
In-Reply-To: <4BB1EBD4.9030707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 03/30/2010 09:17 PM, Tejun Heo wrote:
> Ah, I see.  sysrq.c's requirement changed between mainline and
> linux-next.  I'll update slabh tree such that it includes slab.h from
> there.

slabh updated such that...

* kmemcheck fix patch is placed before the patch to break implicit
  slab.h inclusion.

* sysrq.c now includes slab.h instead of gfp.h.

* Updated against the current mainline
  9623e5a23724d09283c238960946ec6f65733afe.  Conversion script was run
  again and outputs are compared.  No new dependency appeared since
  the last round.

So, it should now be safe to ignore this patch.

Thanks.

-- 
tejun
