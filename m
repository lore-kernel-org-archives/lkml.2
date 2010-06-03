Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0FCTf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:35:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0FCTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:35:28 -0400
Date: Thu, 3 Jun 2010 15:35:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Lin Mac <mkl0301@gmail.com>
Cc: Git Mailing List <git@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: How do I ignore the changes made by CVS keyword substitution
	efficiently?
Message-ID: <20100603193527.GK28492@bombadil.infradead.org>
References: <AANLkTilhvjn1ypRoKs2CxJdA1zDkaT5i64vh0ZtfjwMk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilhvjn1ypRoKs2CxJdA1zDkaT5i64vh0ZtfjwMk@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 03:13:29AM +0800, Lin Mac wrote:
> I'm merging kernel from others, and they used CVS to manage their
> code, and so do some part of linux kernel. Unfortunatly CVS would
> substitude the keywords in the source, result in unecessary changes in
> the code, like the one in the following diff. In fact, there are
> around 1174 of CVS keywords in the kernel source. I don't want those
> useless changes to get into my tree.

You want the -ko option to cvs checkout/update which will use the
original keywords from the import.

regards, Kyle
