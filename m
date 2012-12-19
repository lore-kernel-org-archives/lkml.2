Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2LSO7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:59:05 -0500
Received: from smtp1.uu.se ([130.238.7.54]:50273 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2LSO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:58:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20689.54803.684081.31731@pilspetsen.it.uu.se>
Date: Wed, 19 Dec 2012 15:58:27 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alexander Kartashov <alekskartashov@parallels.com>
Cc: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, gorcunov@openvz.org,
        xemul@parallels.com
Subject: Re: [PATCH 3/3] kcmp: enable the kcmp syscall when C/R is enabled
In-Reply-To: <1355923677-18249-4-git-send-email-alekskartashov@parallels.com>
References: <1355923677-18249-1-git-send-email-alekskartashov@parallels.com>
	<1355923677-18249-4-git-send-email-alekskartashov@parallels.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kartashov writes:
 > --- a/arch/arm/kernel/calls.S
 > +++ b/arch/arm/kernel/calls.S
 > @@ -387,7 +387,7 @@
 >  /* 375 */	CALL(sys_setns)
 >  		CALL(sys_process_vm_readv)
 >  		CALL(sys_process_vm_writev)
 > -		CALL(sys_ni_syscall)	/* reserved for sys_kcmp */
 > +		CALL(sys_kcmp)	/* reserved for sys_kcmp */

The /* reserved for sys_kcmp */ comment is now obsolete and should be removed.
