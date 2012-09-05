Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab2IETan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:30:43 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34501 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab2IETaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:30:39 -0400
Message-ID: <1346873436.2589.22.camel@lorien2>
Subject: Re: [PATCH] dma-debug: Add dma map/unmap error tracking support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com, rob@landley.net,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Wed, 05 Sep 2012 13:30:36 -0600
In-Reply-To: <1346855696.2589.7.camel@lorien2>
References: <1346595257.4377.5.camel@lorien2>
	 <20120904210555.GG3155@phenom.dumpdata.com>
	 <1346799476.3130.27.camel@lorien2>
	 <20120905115722.GC5400@localhost.localdomain>
	 <1346855696.2589.7.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 08:34 -0600, Shuah Khan wrote:
> On Wed, 2012-09-05 at 07:57 -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > > I did compile a complete list of drivers that don't check dma mapping
> > > errors from my analysis. Are you interested in seeing the full analysis?
> > 
> > Yes, plus the authors of the drivers are probably interested in it as
> > well.
> > ..snip..

Work in progress (I have some ways to go) - but if you want to take an
early look at it:

http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

-- Shuah


