Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1KZUEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:04:34 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33186 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab1KZUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:04:31 -0500
X-Sasl-enc: 06DeVAmmgnqAHsIQ9BKutubeZ8CoGYrxMnhCHMwGolfT 1322337869
Date: Sat, 26 Nov 2011 12:00:12 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 1/7] Documentation: add docs for drivers/zio
Message-ID: <20111126200012.GB11421@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com>
 <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 06:30:20PM +0100, Alessandro Rubini wrote:
> This is documentation for the beta3 release of zio.
> The files match commit 7d37663 in git://ohwr.org/misc/zio.git .
> 
> We are aware the "modules.txt" file is not correct as it lists files
> that are not ready. We decided to avoid fixing it for this RFC
> submission, which won't go upstream anyways.

I think you are using sysfs files here, yet I don't see any
Documentation/ABI files describing those sysfs files and how they are to
be used.  Could you please include them?

thanks,

greg k-h
