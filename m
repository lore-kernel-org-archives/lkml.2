Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2FMTCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:02:18 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1687 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420Ab2FMTCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:02:17 -0400
Message-ID: <1339614135.30984.160.camel@x61.thuisdomein>
Subject: Re: [PATCH] get_maintainer: Fix --help warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 21:02:15 +0200
In-Reply-To: <1339612902.28729.2.camel@joe2Laptop>
References: <1339610958.30984.158.camel@x61.thuisdomein>
	 <1339612902.28729.2.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2012 19:02:15.0589 (UTC) FILETIME=[0C1F7550:01CD4997]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 11:41 -0700, Joe Perches wrote:
> Using --help emits a concatenation error.
> Fix it.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks. This made that warning go away.


Paul Bolle

