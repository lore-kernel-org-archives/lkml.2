Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0GGFly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 01:41:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38427 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0GGFlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 01:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ipYrMasdxodUUPMECP7qcv7V8fZ9WaEc/TywkabD16A1/VOSCqse2/FYLoUlsYFwHn
         UWfJNMHW5yQ4ffs1TwFbNy+t17ONy0ssjGufd+nvMcR/kBwtRa5Xnfr405SwYZIYZR/g
         2wK9uWQOqmFlTH2eeifYHNv7nwfJ7C0x/KOW4=
Message-ID: <4C34139B.6090204@gmail.com>
Date: Wed, 07 Jul 2010 07:41:47 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 11:17 AM, Tejun Heo wrote:
> Arjan, I still think we'll be better off using bound workqueues for
> async but let's first convert without causing behavior difference.
> Either way isn't gonna result in any noticeable difference anyway.  If
> you're okay with the conversion, please ack it.

Ping, Arjan.

Thanks.

--
tejun
