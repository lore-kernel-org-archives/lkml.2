Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1ALTMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:12:15 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28051 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1ALTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:12:12 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Ralph Campbell <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/49] drivers/infiniband: Use vzalloc
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	<cover.1288925424.git.joe@perches.com>
	<2a6dc4ae9321aef16372b34fc65ceda93190af0a.1288925424.git.joe@perches.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 12 Jan 2011 11:12:08 -0800
In-Reply-To: <2a6dc4ae9321aef16372b34fc65ceda93190af0a.1288925424.git.joe@perches.com>
	(Joe Perches's message of "Thu, 4 Nov 2010 20:07:36 -0700")
Message-ID: <adasjwy3piv.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
