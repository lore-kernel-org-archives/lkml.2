Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1EQPuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:50:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1EQPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:50:20 -0400
Date: Tue, 17 May 2011 11:50:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: system hangs 2.6.39-rc7 xfs related
Message-ID: <20110517155018.GB17735@infradead.org>
References: <87ei3y7aei.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ei3y7aei.fsf@sycorax.lbl.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:44:37AM -0700, Alex Romosan wrote:
> my system just sort of locked up and everything that's trying to write
> to disk is stuck. dmesg gives me this:

This looks quite similar to a few other XFS issues in the .39 cycle.
Can you upgrade to latest Linus HEAD which has fixes for these similar
issues and see if that fixes your issues?

