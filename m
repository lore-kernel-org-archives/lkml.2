Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2IRUuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:50:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34943 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab2IRUuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:50:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120918203713.GB19300@phenom.dumpdata.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 13:49:52 -0700
X-Google-Sender-Auth: usw94kG20KamAKdT61nxYGvZt00
Message-ID: <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:37 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> 30 words. ~360 + 29 spaces + NULL = 390?

Just allocate the max then. That's tiny.

And it's actually just 330: max ten characters for an unsigned 32-bit number.

          Linus
