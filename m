Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2L0EnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:43:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38830 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab2L0EnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:43:18 -0500
Date: Thu, 27 Dec 2012 05:43:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: kvm lockdep splat with 3.8-rc1+
Message-ID: <20121227044315.GA17472@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Hillf Danton <dhillf@gmail.com>, kvm list <kvm@vger.kernel.org>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <20121225223045.GA23445@liondog.tnic>
 <CAJd=RBBsJBnDyfC5QUtRwnMFBXATrhxT9t0heNRpNv5DEqe4Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJd=RBBsJBnDyfC5QUtRwnMFBXATrhxT9t0heNRpNv5DEqe4Fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

On Wed, Dec 26, 2012 at 08:18:13PM +0800, Hillf Danton wrote:
> Can you please test with 5a505085f0 and 4fc3f1d66b reverted?

sure can do, but am travelling ATM so I'll run it with the reverted
commits when I get back next week.

Thanks.

-- 
Regards/Gruss,
Boris.
