Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1I1A7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:59:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58647 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1I1A7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:59:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 09:58:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>
Subject: Re: [PATCH v3 1/7] Basic kernel memory functionality for the Memory
 Controller
Message-Id: <20110928095826.eb8ebc8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4E81084F.9010208@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-2-git-send-email-glommer@parallels.com>
	<20110926193451.b419f630.kamezawa.hiroyu@jp.fujitsu.com>
	<4E81084F.9010208@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 20:18:39 -0300
Glauber Costa <glommer@parallels.com> wrote:

> On 09/26/2011 07:34 AM, KAMEZAWA Hiroyuki wrote:
> > On Sun, 18 Sep 2011 21:56:39 -0300
> > Glauber Costa<glommer@parallels.com>  wrote:
"If parent sets use_hierarchy==1, children must have the same kmem_independent value
> > with parant's one."
> >
> > How do you think ? I think a hierarchy must have the same config.
> BTW, Kame:
> 
> Look again (I forgot myself when I first replied to you)
> Only in the root cgroup those files get registered.
> So shouldn't be a problem, because children won't even
> be able to see them.
> 
> Do you agree with this ?
> 

agreed.

Thanks,
-Kame

