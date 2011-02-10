Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1BJJFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:05:23 -0500
Received: from mx0.aculab.com ([213.249.233.131]:49405 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753180Ab1BJJFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:05:17 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Date: Thu, 10 Feb 2011 09:02:47 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AC47@saturn3.aculab.com>
In-Reply-To: <20110210003935.GA6034@core.coreip.homeip.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Thread-Index: AcvIurmZ9BgTQ11VT8amBAn4Qe4jBgARmS6A
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > I was completely unaware of that "feature". I hunch that many
drivers
> > are incapable of dealing with an unbind while they are still open.
> 
> Hmm, maybe older drivers... Anythig hotpluggable (USB, PCI, etc)
should
> be in a better shape because they expect to be yanked at any time.

Whim and prayer ???

	David


