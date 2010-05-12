Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0ELUwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab0ELUwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:52:21 -0400
Date: Wed, 12 May 2010 17:23:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alexander Graf <agraf@suse.de>
Cc: Hollis Blanchard <hollis@penguinppc.org>,
       Roel Kluin <roel.kluin@gmail.com>, kvm-ppc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>
Subject: Re: Keep index within boundaries in kvmppc_44x_emul_tlbwe()
Message-ID: <20100512202311.GA19308@amt.cnet>
References: <4BE6D437.9000200@gmail.com>
 <AANLkTil_SWX1iPKRmD_YQgtgQcCzV27MEQwP6tPPQRXL@mail.gmail.com>
 <EF12637D-6AA6-4F95-B806-BADACFB16B00@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF12637D-6AA6-4F95-B806-BADACFB16B00@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 01:10:49AM +0200, Alexander Graf wrote:
> 
> On 11.05.2010, at 00:58, Hollis Blanchard wrote:
> 
> > On Sun, May 9, 2010 at 8:26 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> >> An index of KVM44x_GUEST_TLB_SIZE is already one too large.
> >> 
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > 
> > Acked-by: Hollis Blanchard <hollis@penguinppc.org>
> 
> Acked-by: Alexander Graf <agraf@suse.de>

Applied, thanks.

