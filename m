Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2DJQCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:02:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33498 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2DJQCU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 10 Apr 2012 12:02:20 -0400
Message-Id: <4F8475A7020000780007D139@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 10 Apr 2012 17:02:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Jens Axboe" <axboe@kernel.dk>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkfront: properly name all devices
References: <4F7DD852020000780007CC2A@nat28.tlf.novell.com>
 <alpine.DEB.2.00.1204101645000.15151@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1204101645000.15151@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.04.12 at 17:50, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Would you be up for writing a couple of lines under Documentation to
> clearly state what device names are going to be given by blkfront in
> correspondence to vdev numbers?

I'm not really eager to, and in order to be useful, this should imo include
the compat mapping, and specifically for this I'd prefer someone (you?)
who was involved in putting this together to do eventual write-ups for it.

Jan

