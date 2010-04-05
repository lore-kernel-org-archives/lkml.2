Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0DEXwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:52:11 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27349 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab0DEXwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:52:08 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH8UukurR7Ht/2dsb2JhbACbTXGfcZhJhQcEgyQ
X-IronPort-AV: E=Sophos;i="4.51,367,1267401600"; 
   d="scan'208";a="110532399"
From: Roland Dreier <rdreier@cisco.com>
To: Taras Glek <tglek@mozilla.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 05 Apr 2010 16:52:03 -0700
In-Reply-To: <4BBA6776.5060804@mozilla.com> (Taras Glek's message of "Mon, 05
	Apr 2010 15:43:02 -0700")
Message-ID: <adaljd1790c.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost certainly teaching my grandmother to suck eggs, but are you aware
of the work Michael Meeks has done on improving openoffice.org startup time?
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
