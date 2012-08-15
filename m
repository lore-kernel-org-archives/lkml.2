Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2HOIUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:20:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2HOIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:20:16 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 04:20:16 EDT
Subject: Re: [PATCH 15/21] net sched: Pass the skb into change so it can
 access NETLINK_CB
From: Jamal Hadi Salim <jhs@mojatatu.com>
Reply-To: jhs@mojatatu.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>
In-Reply-To: <1344889115-21610-15-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
	 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
	 <1344889115-21610-15-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Aug 2012 04:11:54 -0400
Message-ID: <1345018314.20443.4.camel@mojatatu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 13:18 -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> cls_flow.c plays with uids and gids.  Unless I misread that
> code it is possible for classifiers to depend on the specific uid and
> gid values.  Therefore I need to know the user namespace of the
> netlink socket that is installing the packet classifiers.  Pass
> in the rtnetlink skb so I can access the NETLINK_CB of the passed
> packet.  In particular I want access to sk_user_ns(NETLINK_CB(in_skb).ssk).
> 
> Pass in not the user namespace but the incomming rtnetlink skb into
> the the classifier change routines as that is generally the more useful
> parameter.
> 
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>


Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

