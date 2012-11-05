Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2KEPjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:39:35 -0500
Received: from twin.jikos.cz ([89.185.236.188]:54387 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2KEPjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:39:32 -0500
Date: Mon, 5 Nov 2012 16:39:02 +0100
From: David Sterba <dave@jikos.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Chris Mason <chris.mason@fusionio.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] fs/btrfs: drop if around WARN_ON
Message-ID: <20121105153902.GK3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Julia Lawall <Julia.Lawall@lip6.fr>,
	Chris Mason <chris.mason@fusionio.com>,
	kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
 <1351974625-10282-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351974625-10282-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 09:30:18PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Just use WARN_ON rather than an if containing only WARN_ON(1).
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Reviewed-by: David Sterba <dsterba@suse.cz>
