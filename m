Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1EQLXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:23:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:51108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1EQLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:23:42 -0400
Subject: Re: [PATCH] Add $KERNELRELEASE to firmware install path
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arun Sharma <asharma@fb.com>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 17 May 2011 12:23:38 +0100
In-Reply-To: <20110516142118.GM13293@sepie.suse.cz>
References: <20110505173939.GA20575@dev1756.snc6.facebook.com>
	 <4DC3CA39.30806@suse.cz> <1304677113.20656.2.camel@i7.infradead.org>
	 <20110506184438.GA30417@dev1756.snc6.facebook.com>
	 <1304708557.20656.49.camel@i7.infradead.org>
	 <20110506223727.GA29011@dev1756.snc6.facebook.com>
	 <20110516142118.GM13293@sepie.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1305631419.8008.106.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 16:21 +0200, Michal Marek wrote:
> 
> make deb-pkg generates a separate package with the firmware files. I
> would suggest we do the same for rpm. 

No. You should ignore the firmware files *completely*.

-- 
dwmw2

