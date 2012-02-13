Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2BMNAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:00:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2BMNAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:00:23 -0500
Date: Mon, 13 Feb 2012 15:00:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dor Laor <dlaor@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Hoff <christian.hoff@de.ibm.com>,
        borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Message-ID: <20120213130005.GB26773@redhat.com>
References: <4F312492.1040002@de.ibm.com>
 <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
 <4F313526.2050907@redhat.com>
 <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
 <4F3390FB.80107@redhat.com>
 <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
 <4F38B657.7060405@de.ibm.com>
 <4F38C27E.7030300@redhat.com>
 <1329136806.9333.383.camel@haakon2.linux-iscsi.org>
 <4F3907EB.4030402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3907EB.4030402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
> Only if you use the pci multi-function option but that kills
> standard hot unplug

It doesn't kill it as such, rather you can't unplug luns individually.
