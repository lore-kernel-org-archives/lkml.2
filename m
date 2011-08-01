Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1HAUJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:09:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1HAUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:09:01 -0400
Date: Mon, 1 Aug 2011 22:08:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, Andi Kleen <andi@firstfloor.org>,
        dan@aloni.org, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        stable@vger.kernel.org
Subject: Re: [stable] [PATCH] [26/98] af_unix: Only allow recv on connected seqpacket sockets.
Message-ID: <20110801200857.GE27083@one.firstfloor.org>
References: <20110726534.972201586@firstfloor.org> <20110727003518.6DA772403FF@tassilo.jf.intel.com> <4E3035BE.6090908@canonical.com> <m1sjprfryg.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjprfryg.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For 2.6.38, and Andi's 2.6.35 which has the potential for an
> unprivileged process to trigger an oops, it seems irresponsible to me to
> not include this change.  People who exploit kernel flaws seem good at
> taking random Oops's and converting them into methods for privilege
> escalation.

I'll ship 2.6.25.14 without the patch, but can you guys please come to a 
conclusion whether the patch is useful or not. I'll reconsider it for .15.

Thanks,

-Andi
