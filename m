Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1AQWnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:43:11 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:57444 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1AQWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:43:09 -0500
Subject: Re: [PATCH] target: remove duplicate include of
	target/target_core_device.h from drivers/target/target_core_hba.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1101172326060.27021@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net>
	 <1295302951.22813.227.camel@haakon2.linux-iscsi.org>
	 <alpine.LNX.2.00.1101172326060.27021@swampdragon.chaosbits.net>
Content-Type: text/plain
Date: Mon, 17 Jan 2011 14:43:05 -0800
Message-Id: <1295304185.22813.247.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 23:26 +0100, Jesper Juhl wrote:
> On Mon, 17 Jan 2011, Nicholas A. Bellinger wrote:
> 
> > On Mon, 2011-01-17 at 22:46 +0100, Jesper Juhl wrote:
> > > drivers/target/target_core_hba.c includes target/target_core_device.h 
> > > twice - the two includes are even on two lines next to each other.
> > > This patch removes the duplicate include.
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > 
> > Committed as:
> > 
> > [linus-38-rc1 95f39d1] target: remove duplicate include target_core_device.h
> > 
> > Please let me know if you have more include cleanups so they can be git
> > squashed'  into a single commit for scsi-post-merge-2.6.git/for-jejb.
> > 
> I only found that one so far...
> 

<nod>  So for minor stuff like this (especially when the merge window is
winding down) feel tree to send this to me directly and CC linux-scsi
and I will make sure this gets in via scsi-post-merge-2.6.git/for-jejb.

--nab

