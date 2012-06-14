Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2FNNDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:03:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46426 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab2FNNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:03:11 -0400
Date: Thu, 14 Jun 2012 08:59:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: Re: linux-next: manual merge of the net-next tree with the wireless
 tree
Message-ID: <20120614125953.GA3128@tuxdriver.com>
References: <20120614131256.2fed671219b8d571a47987c2@canb.auug.org.au>
 <4FD96D85.4010505@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD96D85.4010505@qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:20:13AM +0530, Mohammed Shafi Shajakhan wrote:
> Hi Stephen,
> 
> On Thursday 14 June 2012 08:42 AM, Stephen Rothwell wrote:
> >Hi all,
> >
> >Today's linux-next merge of the net-next tree got a conflict in
> >drivers/net/wireless/ath/ath9k/main.c between commit bcb7ad7bcbef
> >("ath9k: Fix softlockup in AR9485") from the wireless tree and commit
> >ef1b6cd9a1ba ("ath9k: Group link monitoring logic") from the net-next
> >tree.
> >
> >The latter removes the code modified by the former, so I did that.  The
> >fix from the former patch may be needed elsewhere now.

That sounds right.

> the back ported version of this patch is recently sent
> http://www.spinics.net/lists/linux-wireless/msg92125.html

I have it in wireless-next already...thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
