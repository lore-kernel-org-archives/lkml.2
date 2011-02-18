Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1BRAoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:44:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37749 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752175Ab1BRAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:43:57 -0500
Date: Fri, 18 Feb 2011 00:43:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110218004354.GB27668@opensource.wolfsonmicro.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <4D5C8D62.4060809@bluewatersys.com> <201102171649.57457.manningc2@actrix.gen.nz> <20110217234154.GA1474@kroah.com> <20110218000150.GA27668@opensource.wolfsonmicro.com> <20110218003353.GA25386@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218003353.GA25386@kroah.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:33:53PM -0800, Greg KH wrote:
> On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:

> > For the proc stuff - for tracing stuff then tracepoints are likely to be
> > a good option if it's useful to people.

> Then use the in-kernel tracing functionality, don't roll your own.  And
> that is not in /proc, so it should be there for this filesystem either.

That'd be the tracepoints I was mentioning, then...
