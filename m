Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0G2RkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0G2RkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:40:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] ptrace: optimize exit_ptrace() for the likely case
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 July 2010 17:12:29 +0200 <20100729151229.GA24754@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
	<20100721144944.5351c741.akpm@linux-foundation.org>
	<20100721222529.EFBAA400B6@magilla.sf.frob.com>
	<20100722090524.GA6647@redhat.com>
	<1279874705.2096.1274.camel@ymzhang.sh.intel.com>
	<20100723173453.GA29831@redhat.com>
	<1280120732.2085.3.camel@ymzhang.sh.intel.com>
	<20100726085324.GA32223@redhat.com>
	<1280193353.2085.15.camel@ymzhang.sh.intel.com>
	<20100729151229.GA24754@redhat.com>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20100729174004.DC8FA40202@magilla.sf.frob.com>
Date: Thu, 29 Jul 2010 10:40:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
