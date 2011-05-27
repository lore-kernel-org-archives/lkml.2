Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1E0IBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:01:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681Ab1E0IA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:00:59 -0400
Date: Fri, 27 May 2011 10:00:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/12] x86, mce: introduce mce_gather_info()
Message-ID: <20110527080051.GB19300@elte.hu>
References: <4DDF21DE.9040705@jp.fujitsu.com>
 <4DDF23F5.1090206@jp.fujitsu.com>
 <BANLkTinCRX3YOXwuphRTBS=OcHuC07a1jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinCRX3YOXwuphRTBS=OcHuC07a1jw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@gmail.com> wrote:

> 2011/5/26 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> 
> > As the result the mce_get_rip() is integrated and unnecessary 
> > zero-ing is removed.  This also fix an issue pointed by Tony Luck 
> > that RIP is required to make some decision about error severity 
> > (for SRAR errors) but it was retrieved later in the handler.
> 
> To keep the credit path accurate, that was one of the pieces I 
> picked up from Andi.

At minimum an explanation should be put into the code. Small, hidden 
dependencies might be common job security moves in the closed source 
world but this is open source ;-)

Thanks,

	Ingo
