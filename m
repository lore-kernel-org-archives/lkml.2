Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2LGJzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:55:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2LGJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:55:46 -0500
Date: Fri, 7 Dec 2012 09:55:38 +0000
From: Jamie Iles <jamie.iles@oracle.com>
To: Jamie Iles <jamie.iles@oracle.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] scripts/sortextable: support objects with more than 64K
 sections.
Message-ID: <20121207095538.GF28779@cedar>
References: <1352106404-11038-1-git-send-email-jamie.iles@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352106404-11038-1-git-send-email-jamie.iles@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:06:44AM +0000, Jamie Iles wrote:
> Building with a large config and -ffunction-sections results in a large
> number of sections and sortextable needs to be able to handle that.
> Implement support for > 64K sections as modpost does.
> 
> Cc: David Daney <david.daney@cavium.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
> ---

Ping on this one?  I'm not sure who should take this one?

Thanks,

Jamie
