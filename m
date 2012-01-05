Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2AETVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:21:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2AETVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:21:32 -0500
Date: Thu, 5 Jan 2012 19:21:29 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Marco Navarra <fromenglish@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Checkpatch possible false positive
Message-ID: <20120105192129.GE13467@shadowen.org>
References: <20111222183928.GB16245@europa.casa.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222183928.GB16245@europa.casa.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 07:39:29PM +0100, Marco Navarra wrote:
> Hello
> 
> after running checkpatch on some files, it returns "ERROR: Macros with
> complex values should be enclosed in parenthesis" while processing
> code like this:
> #define SOMEVALUE 'x'
> 
> It happens on agpgart.h, checkpatch complains about line 30 that
> corresponds to:
> #define AGPIOC_BASE       'A'
> Running it on elf.h returns the same error on these lines
> #define ELFMAG1         'E'
> #define ELFMAG2         'L'
> #define ELFMAG3         'F'
> 
> Do you think this could be a false positive?
> The tree is linux-next and checkaptch version is 0.32

It does seem likley this is something which can be without ()'s.  I will
see if we can stop it being picked up.

-apw
