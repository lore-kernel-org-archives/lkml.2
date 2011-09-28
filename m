Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1I1Hmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:41869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1I1Hmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:42:32 -0400
Subject: Re: [PATCH 4/9] kstaled: minimalistic implementation.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Date: Wed, 28 Sep 2011 09:41:46 +0200
In-Reply-To: <1317170947-17074-5-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	 <1317170947-17074-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317195706.5781.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 17:49 -0700, Michel Lespinasse wrote:
> +static int kstaled(void *dummy)
> +{
> +       while (1) {

> +       }
> +
> +       BUG();
> +       return 0;       /* NOT REACHED */
> +} 

So if you build with this junk (as I presume distro's will), there is no
way to disable it?
