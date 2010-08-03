Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0HCNBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:01:51 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:58609 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab0HCNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:01:50 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] iBFT features for v2.6.36
Date: Tue, 3 Aug 2010 08:56:43 -0400
User-Agent: KMail/1.9.10
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, pjones@redhat.com, lenb@kernel.org,
        michaelc@cs.wisc.edu, mcb30@ipxe.org
References: <20100802143642.GA15428@hera.kernel.org> <201008022108.04024.konrad@kernel.org> <4C577EFA.4070003@zytor.com>
In-Reply-To: <4C577EFA.4070003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008030856.44451.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is the tools state ? For iBFT, iscsi-initiator-utils scans
> > the /sys/firmware directory to extract the relevant data and does its
> > thing. Are there tools for AoE, SCSI RDMA Protocol (SRP), and in-memory
> > disk?
>
> I don't know about AoE and SRP (Michael Brown <mcb30@ipxe.org> would
> know), but I have a tool which scans for mBFT directly out of /dev/mem,
> which is of course kind of ugly.  It's shipped with the Syslinux
> distribution in the utils/ directory.

Ok. Let me talk to Michael Brown about this and see what the interests are. 
This "unification" work would be post v2.6.36 thought.
