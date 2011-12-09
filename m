Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab1LIQHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:07:13 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:50322 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788Ab1LIQHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:07:11 -0500
Date: Fri, 9 Dec 2011 16:06:40 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Kevin Cernekee <cernekee@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH 04/62] mips: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111209160639.GA30988@linux-mips.org>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-5-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-5-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:26:44PM +0800, Cong Wang wrote:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

I assume you want to merge this patch as part of a single series?

  Ralf
