Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2ISHJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:09:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41790 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2ISHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209181319191.25146@chino.kir.corp.google.com>
References: <20120918150543.GA14718@redhat.com>
	<00000139da509650-e5756e3f-f538-4735-afcd-c3c8ac9035b7-000000@email.amazonses.com>
	<alpine.DEB.2.00.1209181227190.25146@chino.kir.corp.google.com>
	<20120918195412.GB27689@redhat.com>
	<alpine.DEB.2.00.1209181319191.25146@chino.kir.corp.google.com>
Date: Wed, 19 Sep 2012 10:09:01 +0300
X-Google-Sender-Auth: -uDynAbcBLQBrY342aaKFIBFEWg
Message-ID: <CAOJsxLGHgeCx1vB80-=KxRVEmNn2xACQmHs3STwr-c5OgZ6nSQ@mail.gmail.com>
Subject: Re: Taint kernel when we detect a corrupted slab.
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Dave Jones wrote:
>> It doesn't seem worth adding a new taint flag for this, so just re-use
>> the one from 'bad page'
>>
>> Signed-off-by: Dave Jones <davej@redhat.com>

On Tue, Sep 18, 2012 at 11:19 PM, David Rientjes <rientjes@google.com> wrote:
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks!
