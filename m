Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1BBVFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:05:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1BBVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:05:10 -0500
Date: Wed, 2 Feb 2011 16:05:08 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH] perf: fix gcc 4.6.0 issues with tools/perf
Message-ID: <20110202210508.GA760@bombadil.infradead.org>
References: <20110124161304.GK27353@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124161304.GK27353@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:13:04AM -0500, Kyle McMartin wrote:
> Hi Ingo,
> 
> GCC 4.6.0 in Fedora rawhide turned up some compile errors in tools/perf
> due to the -Werror=unused-but-set-variable flag.
> 

ping?
