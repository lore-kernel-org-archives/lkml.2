Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0KEVe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:34:57 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:44169 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0KEVez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:34:55 -0400
Date: Fri, 5 Nov 2010 22:35:04 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, akpm <akpm@linux-foundation.org>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: Re: [PATCH] leds-net5501: taints kernel, add license
Message-ID: <20101105223504.2ba8f261@linux.lan.towertech.it>
In-Reply-To: <20101104102800.6b1cc210.randy.dunlap@oracle.com>
References: <20101104102800.6b1cc210.randy.dunlap@oracle.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010 10:28:00 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Alessandro, why does this module not have a module_exit() function?
> I.e., why can it not be unloaded?
> 

 I believe there's no particular reason. 
 Bjarke Istrup Pedersen is taking care of this code (CCd).

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

