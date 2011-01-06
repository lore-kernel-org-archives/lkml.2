Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1AFC7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:59:10 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:46483 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AFC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:59:08 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADq/JE2rRN+K/2dsb2JhbACkHXOmPpg7hUwEhGiGIg
X-IronPort-AV: E=Sophos;i="4.60,281,1291593600"; 
   d="scan'208";a="310927442"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "J.H." <warthog9@kernel.org>, David Brown <davidb@codeaurora.org>,
        sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>
	<20101220204936.GA21290@huya.qualcomm.com>
	<4D0FFC4B.9050301@kernel.org> <ada62u3dkv2.fsf@cisco.com>
	<20110105154818.56b9976c.randy.dunlap@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 05 Jan 2011 18:58:49 -0800
In-Reply-To: <20110105154818.56b9976c.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Wed, 5 Jan 2011 15:48:18 -0800")
Message-ID: <adawrmid9g6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Let's not mislead the reader of a crash dump, please.  How about:

 > +	printk(KERN_EMERG "last /proc..net open:  %s\n", last_procfs_open);
 > +	printk(KERN_EMERG "last /proc..net close: %s\n", last_procfs_close);

Fair enough... to be clear I wasn't proposing this patch be merged
anywhere -- it's just for debugging this kernel.org crash.'
