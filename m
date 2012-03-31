Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2CaTPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:15:12 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:45873 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2CaTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:15:08 -0400
Message-ID: <1333221304.30812.5.camel@obelisk.thedillows.org>
Subject: Re: [ANNOUNCE] Linux hits 20 Gb/s stream to disk levels over
 Infiniband
From: David Dillow <dave@thedillows.org>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 31 Mar 2012 15:15:04 -0400
In-Reply-To: <CA+ekxPWHbOsa1BChpPvr4Bzj=8YixLDWA2TWtRyHSQ43QqVdqw@mail.gmail.com>
References: <CA+ekxPWHbOsa1BChpPvr4Bzj=8YixLDWA2TWtRyHSQ43QqVdqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 11:28 -0600, Jeffrey Merkey wrote:
> Made it to 20 Gb/s network packet capture stream to disk performance
> levels over Infiniband fabrics on Linux.

I'm assuming that the interesting part is the 20 Gbits/s capture? And at
minimum packet sizes, I'd hope. Linux has been able to stream more than
5 GBytes/s (40 Gbits/s) to disk for several years now over SRP.

>  Will be trying this on 3.0
> after I work through the OFED issues (long list).  Post the results
> from 3.0.  These are from 2.6.XX series kernels.

You may find it easier to use a recent RedHat or SUSE with an upstream
kernel. I know that RHEL6 userland is compatible with the upstream
kernel's Infiniband, and OFED is moving its kernel work to a "backport
upstream" model for OFED 3.2.

> Linux f_cking ROCKS!!!

Indeed it does.

