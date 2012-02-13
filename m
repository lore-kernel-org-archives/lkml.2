Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2BMLIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 06:08:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36730 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2BMLI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 06:08:29 -0500
MIME-Version: 1.0
In-Reply-To: <4F38B657.7060405@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
	<4F30F4EE.4080607@redhat.com>
	<4F311154.9080407@de.ibm.com>
	<4F3119A0.7080005@redhat.com>
	<4F312492.1040002@de.ibm.com>
	<OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
	<4F313526.2050907@redhat.com>
	<OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
	<4F3390FB.80107@redhat.com>
	<1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
	<4F38B657.7060405@de.ibm.com>
Date: Mon, 13 Feb 2012 12:08:27 +0100
X-Google-Sender-Auth: t9Z3HR3tEqILGhF8-ChkYHfmbuk
Message-ID: <CAO+b5-qADXdd4_MUn_yNNXtYSyEBdmT+iW0AtdqjyAcGp=H6ZA@mail.gmail.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
From: Bart Van Assche <bvanassche@acm.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Hoff <christian.hoff@de.ibm.com>,
        borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 8:05 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 12/02/12 21:16, James Bottomley wrote:
> > Could someone please explain to me why you can't simply fix virtio-blk?
>
> I dont think that virtio-scsi will replace virtio-blk everywhere. For non-scsi
> block devices, image files or logical volumes virtio-blk seems to be the right
> approach, I think.
>
> > Or would virtio-blk maintainers give a reason why they're unwilling to
> > have it fixed?
>
> I dont consider virtio-blk broken. It just doesnt cover everything.

Although I'm not sure whether that helps here: since about a year
there is software present in the upstream kernel that allows to use
any block device or even a file as a SCSI device.

Bart.
