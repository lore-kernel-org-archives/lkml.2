Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1ISJBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:01:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55729 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752975Ab1ISJBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:01:43 -0400
Subject: Re: [RFC v3] arm: Add platform bus driver for memory mapped virtio
 device
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Michael S.Tsirkin" <mst@redhat.com>
In-Reply-To: <874o09ryzm.fsf@rustcorp.com.au>
References: <1316191623-3835-1-git-send-email-pawel.moll@arm.com>
	 <4E7380FD.1030200@us.ibm.com>  <874o09ryzm.fsf@rustcorp.com.au>
Date: Mon, 19 Sep 2011 10:01:34 +0100
Message-ID: <1316422894.3014.1.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 19 Sep 2011 09:01:34.0946 (UTC) FILETIME=[BB84C420:01CC76AA]
X-MC-Unique: 111091910013707101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Have you written a specification for this device?
> > 
> > Rusty maintains a formal spec for all virtio devices at:
> > 
> > http://ozlabs.org/~rusty/virtio-spec/
> > 
> > The spec should be written before merging the code to make sure that there 
> > aren't future compatibility problems.
> 
> A good idea, but the current spec is for PCI.  I wonder if we should
> move the PCI part out to an appendix and make it more general?
> 
> Meanwhile, perhaps this would be suitable as an appendix.

Yes, that sounds reasonable. I'll work on this during the week, but in
the meantime - does the driver look good enough to ask Peter to invest
his time into QEMU side?

Cheers!

Paweł


