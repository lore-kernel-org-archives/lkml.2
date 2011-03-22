Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1CVRNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:13:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:55423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab1CVRNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:13:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,225,1299484800"; 
   d="scan'208";a="722972818"
Date: Tue, 22 Mar 2011 10:12:51 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: linux-usb@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Any USB gadget AIO interface users?
Message-ID: <20110322171251.GA4455@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone successfully used the asynchronous I/O gadgetfs interface
before?  Specifically, has anyone used it for high-bandwidth isochronous
traffic?

I ask because I remember discovering about four years ago that there
were several brain-twisty bugs in the in-kernel asynchronous I/O layer
that gadgetfs uses.  The AIO core also seemed to be largely
unmaintained.  Is this still true?

Sarah Sharp
