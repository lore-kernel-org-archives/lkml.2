Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab0GUSkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:40:43 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:58243 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab0GUSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:40:41 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 04/18] ib/qib: use generic_file_llseek
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	<1278538820-1392-5-git-send-email-arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 21 Jul 2010 11:40:41 -0700
In-Reply-To: <1278538820-1392-5-git-send-email-arnd@arndb.de> (Arnd Bergmann's
	message of "Wed, 7 Jul 2010 23:40:06 +0200")
Message-ID: <ada7hkooeza.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
