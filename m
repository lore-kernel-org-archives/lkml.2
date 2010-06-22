Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0FVA7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:59:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26610 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0FVA7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:59:13 -0400
Date: Mon, 21 Jun 2010 20:57:23 -0400
From: Chris Mason <chris.mason@oracle.com>
To: "jeff.liu" <jeff.liu@oracle.com>
Cc: Tao Ma <tao.ma@oracle.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: Don't return extent in fiemap if we meet
 with a hole.
Message-ID: <20100622005723.GJ23009@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	"jeff.liu" <jeff.liu@oracle.com>, Tao Ma <tao.ma@oracle.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1277102222-3310-1-git-send-email-tao.ma@oracle.com>
 <4C1F167D.3040908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F167D.3040908@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4C200AE1.0070:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:36:29PM +0800, jeff.liu wrote:
> Hi Chris,
> 
> Could you please also consider another tiny patch below combine with Tao's?
> It fix extent flags to FIEMAP_FLAG_UNWRITTEN if it was fallocate(2) and its "em->block_start ==
> EXTENT_MAP_LAST_BYTE".

Thanks, will do.

-chris
