Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0GUPnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:43:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0GUPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:43:12 -0400
Message-ID: <4C47154D.8000008@kernel.org>
Date: Wed, 21 Jul 2010 17:42:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C4712B4.9040706@kernel.org> <4C470B46.4040604@kernel.org> <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com> <15189.1279725944@redhat.com> <15376.1279726700@redhat.com>
In-Reply-To: <15376.1279726700@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 15:42:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 05:38 PM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> If I'm correctly understanding what you're saying, the code already
>> does about the same thing.
> 
> Cool.
> 
> Btw, it seems to work for fscache.  Feel free to add my Acked-by to your
> patches.

Great, I'll start working on the debugging stuff once things settle
down a bit.  Thank you.

-- 
tejun
