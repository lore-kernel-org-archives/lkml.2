Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab2FGSt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:49:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29530 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763Ab2FGSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:49:57 -0400
Date: Thu, 7 Jun 2012 14:42:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dan.magenheimer@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] mm: frontswap: remove casting from function calls
 through ops structure
Message-ID: <20120607184253.GD9472@phenom.dumpdata.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:55:05PM +0200, Sasha Levin wrote:
> Removes unneeded casts.

On the cover letter can you do a git diff --stat linus/master.. so
that at a quick glance I can figure out how much we are shaving off
the code?

Thanks!

