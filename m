Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1IAW4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:10 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43136 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab1IAW4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:04 -0400
X-Sasl-enc: VZ7e58jYERTPAJIzxSQ+IAmlPA1gafusvFXbOmKzgTxP 1314917763
Date: Thu, 1 Sep 2011 15:54:01 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: [patch 0/8] Samsung Laptop driver patches
Message-ID: <20110901225401.GA26870@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Sorry for holding on to these for so long, but here are 8 patches for
the samsung-laptop driver.  The patches are against Linus's current
tree, but should apply just fine to linux-next as well.

If there are any problems with them, please let me know.

Oh, and if anyone wants to take over maintainership of this driver,
please let me know.  I no longer have the hardware to be able to test
any changes for it, which is why this took so long to get pushed out to
you.

thanks,

greg k-h
