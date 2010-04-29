Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab0D3TZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:25:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60860 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab0D3QsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:48:07 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloJAN9Y2UurR7Hu/2dsb2JhbACdD3EEoxaZeIUQBIM8
X-IronPort-AV: E=Sophos;i="4.52,296,1270425600"; 
   d="scan'208";a="522611032"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Nicolas Palix <npalix@diku.dk>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
	<1272316279-12042-2-git-send-email-npalix@diku.dk>
	<1272317821.15953.107.camel@Joe-Laptop.home>
	<201004270020.09447.npalix@diku.dk> <4BD61266.5020905@xenotime.net>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 29 Apr 2010 10:01:54 -0700
In-Reply-To: <4BD61266.5020905@xenotime.net> (Randy Dunlap's message of "Mon,
	26 Apr 2010 15:23:34 -0700")
Message-ID: <adaaasmyyyl.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +		"Take particularly attention when using the \"patch\" mode\n"\
 > 
 > 		      particular

Actually, "take particular attention" is not particularly grammatical.
I might phrase this as

  Be especially careful when using the "patch" mode to review the patch
  you are about to submit.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
