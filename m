Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0CXWcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:32:04 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:57550 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0CXWcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:32:01 -0400
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts/cvt_kernel_style.pl: kernel style source code reformatter
Date: Wed, 24 Mar 2010 23:31:58 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       devel@driverdev.osuosl.org, apw@shadowen.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1268191518.1545.228.camel@Joe-Laptop.home> <71f98699c39e03727b17b46995a801015fcc342a.1269460465.git.joe@perches.com>
In-Reply-To: <71f98699c39e03727b17b46995a801015fcc342a.1269460465.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003242332.00074.elendil@planet.nl>
X-OriginalArrivalTime: 24 Mar 2010 22:32:00.0394 (UTC) FILETIME=[D1D34EA0:01CACBA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Joe Perches wrote:
> A script to convert kernel source files to a more conformant style.
> A supplement to or replacement of Lindent.
> A wretched little perl script using regexes.

I've found the script useful, but it does require some experience and 
judgement to use correctly.

For example, with my 'trailing spaces in messages' patches I've found it
is essential to review all changes to avoid e.g. changing output to files 
in /proc. Doing that can be valid, but it probably should not be included 
in the same patch as removing trailing space from kernel messages.

Given that experience and judgement is needed to use many tools correctly,

Supported-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
