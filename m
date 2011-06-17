Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1FQJVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:21:20 -0400
Received: from 8bytes.org ([88.198.83.132]:55081 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1FQJVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:21:19 -0400
Date: Fri, 17 Jun 2011 11:21:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: chrish@techspecs.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: AMD Zacate E350 shows only 2.6GB memory when 8GB
	installed
Message-ID: <20110617092116.GA29299@8bytes.org>
References: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:59:19PM -0700, chrish@techspecs.com wrote:
>    I tried this on Fedora 14 and OpenSuse 11.4 and both exhibit the same
> behavior. 8GB is installed but only 2698476 shows available for use
> using "top" or "free". dmidecode shows 2 4GB DIMMs and the BIOS reports
> 8GB of memory. Memtest reports and tests 8GB of memory. I Googled the
> issue and it seems there are others that also report the same. What to
> do? Thank you.

It was already asked for, but dmesg is certainly helpful. Please send
the dmesg of a kernel boot.

	Joerg

