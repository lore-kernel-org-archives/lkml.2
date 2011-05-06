Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1EFTCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:02:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:59998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1EFTCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:02:40 -0400
Subject: Re: [PATCH] Add $KERNELRELEASE to firmware install path
From: David Woodhouse <dwmw2@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 06 May 2011 20:02:36 +0100
In-Reply-To: <20110506184438.GA30417@dev1756.snc6.facebook.com>
References: <20110505173939.GA20575@dev1756.snc6.facebook.com>
	 <4DC3CA39.30806@suse.cz> <1304677113.20656.2.camel@i7.infradead.org>
	 <20110506184438.GA30417@dev1756.snc6.facebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1304708557.20656.49.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 11:44 -0700, Arun Sharma wrote:
> 
> Without this change, if you have two kernel rpms/debs from different
> kernel versions installed, they'll result in a namespace conflict
> (rpm/deb install will fail), which gets resolved by this patch. 

The packages are broken then. They shouldn't include *any* files
in /lib/firmware.

Fix *that*, and the problem goes away.


-- 
dwmw2

