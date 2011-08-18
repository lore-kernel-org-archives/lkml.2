Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1HRVQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:16:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32998 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1HRVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:16:21 -0400
Date: Thu, 18 Aug 2011 22:16:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Oops in minixfs_statfs
Message-ID: <20110818211620.GX2203@ZenIV.linux.org.uk>
References: <20110816164809.GE2227@zod.bos.redhat.com>
 <20110817021820.GU2203@ZenIV.linux.org.uk>
 <20110817171829.GG2227@zod.bos.redhat.com>
 <20110818211320.GQ2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818211320.GQ2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 05:13:21PM -0400, Josh Boyer wrote:

> +	if (blocks != blocks_needed)
> +		blocks = blocks_needed;

????
