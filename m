Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1DDKfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:35:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1DDKf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:35:29 -0400
Date: Mon, 4 Apr 2011 12:31:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110404103158.GA4300@elte.hu>
References: <1301592656.586.15.camel@jaguar>
 <4D978930.1000909@codemonkey.ws>
 <20110403062117.GA27121@elte.hu>
 <4D982EB8.7080001@redhat.com>
 <BANLkTikkyktU3KL8h71PYLF_ds0C07QKcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikkyktU3KL8h71PYLF_ds0C07QKcg@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> > Well, this is bound to cause confusion as the tool is yet quite immature.
> 
> Yes, that's really unfortunate. I don't care too much what we call the tool 
> but I definitely agree with Ingo that 'kvm' is more discoverable to users. 
> Any suggestions?

Well, lets keep it 'kvm' - if it stays immature it doesnt matter much. If it 
improves it has the right and obvious tool name.

Thanks,

	Ingo
