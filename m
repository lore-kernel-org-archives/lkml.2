Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab0KWVRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:17:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46149 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0KWVRl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 23 Nov 2010 16:17:41 -0500
Date: Tue, 23 Nov 2010 16:18:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH] fix 32-bit PAE bootup of Xen PV guests.
Message-ID: <20101123211801.GA29499@dumpdata.com>
References: <1290544896-20754-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290544896-20754-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 03:41:35PM -0500, Konrad Rzeszutek Wilk wrote:
> I was wondering if you could help me out. The git commit
> b40827fa7268fda8a62490728a61c2856f33830b ("x86-32, mm: Add an initial
> page table for core bootstrapping") crashes 32-bit PAE Xen PV guests.
> 
> I am attaching an RFC patch that works around your patch, but honestly
> I was wondering if there is a better way to make this work for 2.6.37?
> Any recommendations?

Ignore this patch please. Ian's fix (
http://marc.info/?l=linux-kernel&m=128879861204118&w=2) is much cleaner.
