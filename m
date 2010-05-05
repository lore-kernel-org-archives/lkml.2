Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0EESJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:09:26 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:29845 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0EESJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:09:22 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB9R4UurR7Ht/2dsb2JhbACdTXGlJJlkhRMEgz4
X-IronPort-AV: E=Sophos;i="4.52,335,1270425600"; 
   d="scan'208";a="192996319"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [patch v3] infiniband: ulp/iser, fix error retval in iser_create_ib_conn_res
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz>
	<ada634v9644.fsf@roland-alpha.cisco.com>
	<20100317151122.GF5331@bicker>
	<adak4ssi4ky.fsf@roland-alpha.cisco.com>
	<20100402112736.GH5265@bicker>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 05 May 2010 11:09:22 -0700
In-Reply-To: <20100402112736.GH5265@bicker> (Dan Carpenter's message of "Fri,
	2 Apr 2010 14:27:36 +0300")
Message-ID: <ada4oimmd9p.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or, I don't think we ever fixed this.  This patch looks correct to me,
any problem with merging this for 2.6.35?
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
