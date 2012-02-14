Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab2BNN64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:58:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab2BNN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:58:54 -0500
Subject: Re: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Feb 2012 08:58:46 -0500
In-Reply-To: <1329227574.3675.65.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <1329227102.2395.58.camel@deneb.redhat.com>
	 <1329227574.3675.65.camel@mfleming-mobl1.ger.corp.intel.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1329227927.2395.60.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 13:52 +0000, Matt Fleming wrote:
> On Tue, 2012-02-14 at 08:45 -0500, Mark Salter wrote:
> > The c6x patch seems to be missing from the series.
> 
> I don't think it is. It reached lkml.org OK,
> 
> 	https://lkml.org/lkml/2012/2/14/123
> 
> The post to the linux-c6x-dev mailing list is awaiting moderator
> approval but seeing as you were Cc'd on the patch I would have expected
> it to reach your inbox with problems.
> 
Yup. I should have been more patient. I see it now.


