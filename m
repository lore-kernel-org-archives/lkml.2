Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1FBNbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab1FBNbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:31:46 -0400
Date: Thu, 2 Jun 2011 16:30:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH RFC 1/3] virtio_ring: add capacity check API
Message-ID: <20110602133056.GI7141@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
 <8014f898ca6b768d7be626b83c617a1e84adfeb9.1306921434.git.mst@redhat.com>
 <87sjrthti1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjrthti1.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 11:41:50AM +0930, Rusty Russell wrote:
> On Wed, 1 Jun 2011 12:49:46 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Add API to check ring capacity. Because of the option
> > to use indirect buffers, this returns the worst
> > case, not the normal case capacity.
> 
> Can we drop the silly "add_buf() returns capacity" hack then?
> 
> Thanks,
> Rusty.

Sure.
