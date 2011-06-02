Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1FBPpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab1FBPo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:44:59 -0400
Date: Thu, 2 Jun 2011 18:44:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
Subject: Re: [PATCH RFC 3/3] virtio_net: limit xmit polling
Message-ID: <20110602154431.GB11300@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
 <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com>
 <87pqmwj3am.fsf@rustcorp.com.au>
 <20110602133425.GJ7141@redhat.com>
 <OF990F08C5.2ECE35B1-ON652578A3.004DC0FA-652578A3.004E3FE4@in.ibm.com>
 <20110602144346.GA7995@redhat.com>
 <OFFF109303.D838CAE2-ON652578A3.0053357D-652578A3.00549366@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFFF109303.D838CAE2-ON652578A3.0053357D-652578A3.00549366@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 08:56:42PM +0530, Krishna Kumar2 wrote:
> Return value in free_old_xmit() was wrong.

Could you check my latest RFC pls?

-- 
MST
