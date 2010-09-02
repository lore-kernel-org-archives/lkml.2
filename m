Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab0IBES7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 00:18:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:58794 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0IBES6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 00:18:58 -0400
Subject: RE: Memory allocation modifications in ibm_newemac driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A305B@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2F09@Mercury.usurf.usu.edu>
	 , <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A2FBE@Mercury.usurf.usu.edu>
	 , <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A301B@Mercury.usurf.usu.edu>
	 <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC127A305B@Mercury.usurf.usu.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 14:18:50 +1000
Message-ID: <1283401130.16240.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 22:46 +0000, Jonathan Haws wrote:
> 
> Can anyone explain to me why I would be getting this error in the
> first place?  Why is it failing to allocate a page when there are
> pages available?  That does not make any sense to me.

order:1

It's failing to allocate -two- pages.

Cheers,
Ben.


