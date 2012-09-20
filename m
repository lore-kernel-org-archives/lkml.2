Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2ITH1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:27:36 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:58323 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2ITH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:27:35 -0400
Date: Thu, 20 Sep 2012 09:27:32 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] xfrm_user: don't copy esn replay window twice for
 new states
Message-ID: <20120920072732.GC4221@secunet.com>
References: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
 <1348090423-32665-7-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348090423-32665-7-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Sep 2012 07:27:32.0603 (UTC) FILETIME=[6605CCB0:01CD9701]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:33:43PM +0200, Mathias Krause wrote:
> The ESN replay window was already fully initialized in
> xfrm_alloc_replay_state_esn(). No need to copy it again.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

