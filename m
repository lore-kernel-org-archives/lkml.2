Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1FPL0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:26:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52079
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab1FPL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:26:05 -0400
Date: Thu, 16 Jun 2011 07:25:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616112552.GA15816@infradead.org>
References: <4DF93010.1040006@codemonkey.ws>
 <4DF935C1.4020000@codemonkey.ws>
 <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
 <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
 <20110616092429.GA5484@infradead.org>
 <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
 <20110616094810.GA19965@infradead.org>
 <BANLkTikoMZCFzA6jUw+ddHZ3x2cvO_NzhA@mail.gmail.com>
 <20110616100239.GA29262@infradead.org>
 <20110616112230.GD26110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616112230.GD26110@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:22:30PM +0200, Ingo Molnar wrote:
> Such as? I don't think apps can actually know whether disk blocks 
> have been 'instantiated' by a particular filesystem or not, so the 
> manpage:

In general they can't.  The only good use case for sync_file_range
is to paper over^H^H^H^H^H^H^H^H^Hcontrol write back behaviour.

