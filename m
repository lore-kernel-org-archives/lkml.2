Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2KWXyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:54:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65236 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab2KWXy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:54:29 -0500
Date: Fri, 23 Nov 2012 15:55:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, andreas@gaisler.com, sam@ravnborg.org,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] of/address: sparc: Declare of_iomap as an extern
 function for sparc again
Message-ID: <20121123235544.GA1407@kroah.com>
References: <1353669849-23697-1-git-send-email-andreas@gaisler.com>
 <20121123.142110.835354734152648777.davem@davemloft.net>
 <20121123215947.02DDC3E1EC4@localhost>
 <61dbc2ab-5fa4-4095-bbba-11f146ad89a5@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61dbc2ab-5fa4-4095-bbba-11f146ad89a5@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 11:34:20PM +0000, Grant Likely wrote:
> Cc'ing stable since this should go into previous kernels too.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
