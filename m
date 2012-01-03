Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2ACN01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:26:27 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2ACN0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:26:17 -0500
From: Richard Weinberger <richard@nod.at>
To: shemminger@vyatta.com
Cc: davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: xt_physdev has no effect if net.bridge.bridge-nf-call-iptables=0
Date: Tue,  3 Jan 2012 14:26:03 +0100
Message-Id: <1325597164-13459-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <4F025A07.2000304@nod.at>
References: <4F025A07.2000304@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

Here is a fix for the problem I've reported yesterday.
http://marc.info/?l=netfilter-devel&m=132555432331663&w=2

Please review the patch carefully, I'm not a br_netfilter ninja. 8-)

Thanks,
//richard

