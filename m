Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0CXQkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:40:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:12146 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0CXQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:40:51 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPPdqUurR7Ht/2dsb2JhbACbHHOmf5kEhH4Egx4
X-IronPort-AV: E=Sophos;i="4.51,301,1267401600"; 
   d="scan'208";a="171636248"
From: Roland Dreier <rdreier@cisco.com>
To: Anton Starikov <ant.starikov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
References: <bug-15618-10286@https.bugzilla.kernel.org/>
	<20100323102208.512c16cc.akpm@linux-foundation.org>
	<20100323173409.GA24845@elte.hu>
	<alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
	<20100323180002.GA2965@elte.hu>
	<15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 24 Mar 2010 09:40:47 -0700
In-Reply-To: <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com> (Anton
	Starikov's message of "Tue, 23 Mar 2010 19:03:36 +0100")
Message-ID: <adapr2t1xm8.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I will apply this commits to 2.6.32, I afraid current OFED (which I
 > need also) will not work on 2.6.33+.

What do you need from OFED that is not in 2.6.34-rc1?
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
