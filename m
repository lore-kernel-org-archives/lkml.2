Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2FZH2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:28:18 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:33647 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2FZH2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:28:16 -0400
Date: Tue, 26 Jun 2012 09:28:12 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 05/12] avr32: remove km_type definitions
Message-ID: <20120626072812.GA7866@samfundet.no>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
 <1340445863-16111-6-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340445863-16111-6-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 23 Jun 2012 18:04:16 +0800 or thereabout, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

FYI: AVR32 doesn't use the KM_TYPE_NR symbol, so it can fallback to a common
define in include/linux/hugemem.h, ref. other discussions.

<snipp diff kmem_types.h cleanup>

-- 
mvh
Hans-Christian Egtvedt
