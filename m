Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1FPJ5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:57:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab1FPJ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:57:36 -0400
Date: Thu, 16 Jun 2011 11:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616095712.GA10989@elte.hu>
References: <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
 <4DF92C80.3030106@codemonkey.ws>
 <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
 <4DF93010.1040006@codemonkey.ws>
 <4DF935C1.4020000@codemonkey.ws>
 <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
 <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
 <20110616092429.GA5484@infradead.org>
 <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
 <20110616094810.GA19965@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616094810.GA19965@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> > What's the right thing to do here? Is fdatasync() sufficient?
> 
> Yes.

Prasad, Pekka, mind redoing the numbers with fdatasync()?

I'd be surprised if they were significantly worse but it has to be 
done to have apples-to-apples numbers.

Thanks,

	Ingo
