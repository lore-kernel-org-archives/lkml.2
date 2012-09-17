Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2IQHsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:48:43 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:36415 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab2IQHrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:47:48 -0400
Date: Mon, 17 Sep 2012 09:18:53 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfrm_user: return error pointer instead of NULL #2
Message-ID: <20120917071853.GD13023@secunet.com>
References: <1347652712-14584-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347652712-14584-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Sep 2012 07:18:52.0073 (UTC) FILETIME=[B085F990:01CD94A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:58:32PM +0200, Mathias Krause wrote:
> When dump_one_policy() returns an error, e.g. because of a too small
> buffer to dump the whole xfrm policy, xfrm_policy_netlink() returns
> NULL instead of an error pointer. But its caller expects an error
> pointer and therefore continues to operate on a NULL skbuff.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

