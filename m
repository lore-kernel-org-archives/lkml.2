Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1GQJmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:42:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1GQJmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:42:16 -0400
Date: Sun, 17 Jul 2011 12:42:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roopa Prabhu <roprabhu@cisco.com>
Cc: Tom Lendacky <tahm@linux.vnet.ibm.com>,
        Krishna Kumar2 <krkumar2@in.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
Subject: Re: RFT: virtio_net: limit xmit polling
Message-ID: <20110717094201.GB17404@redhat.com>
References: <20110629084206.GA14627@redhat.com>
 <CA4493AD.2E273%roprabhu@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA4493AD.2E273%roprabhu@cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 12:38:05PM -0700, Roopa Prabhu wrote:
> Michael, below are some numbers I got from one round of runs.
> Thanks,
> Roopa

Thanks!
At this point it does not appear like there's any measureable
impact from moving the polling around.

-- 
MST
