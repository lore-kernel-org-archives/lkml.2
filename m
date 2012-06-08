Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2FHOrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:47:52 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:41020 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2FHOrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:47:51 -0400
Message-ID: <1339166867.3870.29.camel@blech>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 16:47:47 +0200
In-Reply-To: <1339165009.26976.60.camel@ul30vt>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>
	 <1339165009.26976.60.camel@ul30vt>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> secure config space access, resource access, DMA mapping services, and
> full interrupt support to userspace.  

I know about VFIO, but we need some support for that stuff relatively
soon. That's the reason why I'm currently working on it to make UIO DMA
capable. My extensions probably do not play well with IOMMUs and they
therefore won't make it to mainline anyhow (i learned that today ;-).

> I'm currently working to get this upstream, probably targeting 3.6 at
> this point, and would love to have more users to help make that
> happen.  

Yes, you are faster than I'm able to ask. 3.6 is a good target and
really would like to support that.

> Please take a look at the vfio-3.4 branch in the tree above.  See this
> tree for Qemu's usage of VFIO for device assignment ...

OK, I take look at it and report back (off the list). Please write me an
email if you need support.

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 69 79844114

