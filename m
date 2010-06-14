Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0FNQfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:35:18 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:33108 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755710Ab0FNQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:35:16 -0400
Date: Mon, 14 Jun 2010 12:35:04 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Norbert Preining <preining@logic.at>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: iwlagn completely unusable with some AP since 2.6.31
Message-ID: <20100614163504.GA10783@elliptictech.com>
Mail-Followup-To: Norbert Preining <preining@logic.at>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <20100614160910.GA10738@gandalf.dynalias.org>
 <20100614162048.GA28894@infradead.org>
 <20100614162438.GB31239@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614162438.GB31239@gamma.logic.tuwien.ac.at>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01:24 Tue 15 Jun     , Norbert Preining wrote:
> Is there a way to restrict git bisect to consider *only* changes in 
> a specific sub-directory (directories) ? That would help.

Yes, there is an optional path argument to git bisect start which does
this, covered in the git-bisect man page.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
