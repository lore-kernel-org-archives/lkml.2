Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2HHIHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:07:17 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58227 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab2HHIHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:07:03 -0400
Date: Wed, 8 Aug 2012 09:06:57 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Wolf <kwolf@redhat.com>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
Message-ID: <20120808080657.GA16887@stefanha-thinkpad.localdomain>
References: <5018FC9B.8040808@redhat.com>
 <501E4615.7060801@profihost.ag>
 <501E4AFD.3020806@redhat.com>
 <501E96BB.5060702@profihost.ag>
 <501EC2E2.8010802@profihost.ag>
 <501F8226.9090500@redhat.com>
 <501F846C.50903@profihost.ag>
 <501FB4A8.6080609@redhat.com>
 <501FBAA2.6050205@redhat.com>
 <5021FE4B.5070701@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5021FE4B.5070701@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12080808-1948-0000-0000-0000029D95CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 07:51:07AM +0200, Stefan Priebe wrote:
> Any news? Was this applied upstream?

Kevin is ill.  He has asked me to review and test patches in his
absence.  When he gets back later this week this will get picked up (and
included in QEMU 1.2).

Here is the tree, it includes this patch:

https://github.com/stefanha/qemu/commits/for-kevin

Stefan

