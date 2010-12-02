Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0LBAdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:33:41 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:24692 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0LBAdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:33:39 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,285,1288569600"; 
   d="scan'208";a="249980812"
From: Roland Dreier <rdreier@cisco.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: "Hefty\, Sean" <sean.hefty@intel.com>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <rolandd@cisco.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] infiniband: core: fix information leak to userspace
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
	<ada39r8ohiz.fsf@cisco.com> <20101112180844.GA11533@albatros>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
	<20101114092252.GA5323@albatros>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Dec 2010 16:33:34 -0800
In-Reply-To: <20101114092252.GA5323@albatros> (Vasiliy Kulikov's message of
	"Sun, 14 Nov 2010 12:22:52 +0300")
Message-ID: <adafwuhm2sh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
