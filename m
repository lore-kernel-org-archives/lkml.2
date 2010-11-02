Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0KBI6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:58:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51490 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0KBI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VRKeA+Z/AM3tDMky6/dWrcXGbvmqjxweYnfcMh2aatk12SbNn7qTqHMXFwIe5ZAGzT
         idnOPUP8oTLihNQJTx7pyoQNIg30VsX7EawdZvZI1soMRU/56UoEXhXy3STXz1Ah7hW9
         XRfjvZ4cylsUnUHF7mLtDl8eixeM8JOR1APrI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPTrc6FpBRTZbDcsOdwpRUayQuE+2K8U8yPorz@mail.gmail.com>
References: <AANLkTinPTrc6FpBRTZbDcsOdwpRUayQuE+2K8U8yPorz@mail.gmail.com>
Date: Tue, 2 Nov 2010 10:57:51 +0200
X-Google-Sender-Auth: xIHQKvQbbQ5cimX8SwWVS9wyJzw
Message-ID: <AANLkTi=tFRb6FYJ0Zi0ybZOr=Wt8_nAP1YO=4Cipg4wE@mail.gmail.com>
Subject: Re: Where is the SLAM (a mutable slab allocator) development happening?
From: Pekka Enberg <penberg@kernel.org>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 9:49 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> while looking through the program of LPC, I have seen a proposal for a
> talk called "SLAM: a mutable slab allocator" [1].
>
> As there was no reference given to the code-base, I went searching on
> the Wild Wild Web and found a thread called "[UnifiedV4 00/16] The
> Unified slab allocator (V4)" posted to LKML.
> It looks to me that these patches went to Pekka's slab/for-next GIT-branch [2].
> I am not sure if this is "SLAM".

I've never heard of such a beast. Lets ask David?
