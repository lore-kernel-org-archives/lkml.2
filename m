Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0K2Cof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:44:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:49854 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0K2Cod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:44:33 -0500
Subject: Re: [PATCH 3/5] fpga: add basic CARMA board support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1283964082-30133-4-git-send-email-iws@ovro.caltech.edu>
References: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
	 <1283964082-30133-4-git-send-email-iws@ovro.caltech.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:38:14 +1100
Message-ID: <1290991094.32570.213.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 09:41 -0700, Ira W. Snyder wrote:
> This adds basic support for the system controller FPGA on the OVRO CARMA
> board. This patch only adds infrastructure that will be used by later
> drivers.

Oh and another comment ...

I'm not sure about drivers/fpga ... in the end, one would expect such a
directory to contain stuff to manipulate FPGAs in the sense of
downloading bitfiles, instanciating devices (device-tree manipulation ?)
etc...

>From what I see in your code, the fact that these are FPGAs is almost
irrelevant, you are providing support for "carma" devices, and such are
no different than some other platform device, they just happen to be
implemented as FPGAs. Or am I missing something ?

Cheers,
Ben.

