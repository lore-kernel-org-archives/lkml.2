Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab1LAXym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:54:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:42355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1LAXym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:54:42 -0500
Message-ID: <1322783661.3729.39.camel@pasglop>
Subject: Re: [PATCH 1/2] MTD: NAND: ndfc: fix compilation error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: dedekind1@gmail.com
Cc: Tanmay Inamdar <tinamdar@apm.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Dec 2011 10:54:21 +1100
In-Reply-To: <1321998220.2222.22.camel@koala>
References: <1321942850-20012-1-git-send-email-tinamdar@apm.com>
	 <1321998220.2222.22.camel@koala>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 23:43 +0200, Artem Bityutskiy wrote:
> On Tue, 2011-11-22 at 11:50 +0530, Tanmay Inamdar wrote:
> > This patch fixes compilation error in ndfc flash driver
> > ---
> >  drivers/mtd/nand/ndfc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Tony Breeds <tony@bakeyournoodle.com> sent a fix for this a bit earlier.

Any reason this isn't in Linus tree yet ?

Ben.


