Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2DOBWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 21:22:20 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40048 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2DOBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 21:22:15 -0400
Subject: Re: [PATCH 0/2] sbp-target: cleanup after merge into single file
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Chris Boot <bootc@bootc.net>, linux1394-devel@lists.sourceforge.net,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        agrover@redhat.com, clemens@ladisch.de
In-Reply-To: <20120415011151.55d14826@stein>
References: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
	 <1334394746-31738-1-git-send-email-bootc@bootc.net>
	 <1334439895.12540.65.camel@haakon2.linux-iscsi.org>
	 <20120415011151.55d14826@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Apr 2012 18:22:12 -0700
Message-ID: <1334452932.12540.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 01:11 +0200, Stefan Richter wrote:
> On Apr 14 Nicholas A. Bellinger wrote:
> > Also, it looks like Stefan has a few more comments from the last round
> > of review..
> 
> Don't consider them blocking.  I would welcome it if the code gets merged
> soon, it looks very nice and maintainable.  The card state <-> session
> state interactions which I was wondering about will be more comfortable for
> me to investigate when it is in mainline; I believe there is no urgency
> for me to look into that.  Other obscure but simple things like making use
> of memory alignment guarantees from firewire-core are more effectively
> addressed if I can send patches rather than comments.

<nod>  In that case, I'll go ahead and add your Acked-by to the initial
merge commit for sbp-target that will be appearing in
target-pending/for-next-merge shortly.

Thanks Stefan!

--nab



