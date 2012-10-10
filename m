Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2JJB7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:59:37 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:37373 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2JJB7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:59:34 -0400
Date: Tue, 9 Oct 2012 21:59:33 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: thekingmen <thekingmen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <321971736.6561388.1349834373175.JavaMail.root@redhat.com>
In-Reply-To: <1349833967.5068.1.camel@anime-power2>
Subject: Re: ASpeed Technologies KMS VGA Driver error in log
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.40.183]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > 
> > Oh thanks for pointing this out, its just left over debug, I'll
> > send a patch
> > to remove it.
> > 
> > Dave.
> 
> Hello,
> I see no changes in the current kernel tree. Maybe you forgot about
> it ?
> 
> 

Not sure what kernel tree you are looking in, should be in Linus tree upstream now.

commit 0273de08c455031335dbea2630208f66106b0c14
Author: Dave Airlie <airlied@gmail.com>
Date:   Mon Sep 3 07:22:16 2012 +1000

    drm/ast: drop debug level on error printk
    
    This was never an error, drop to a debug print.
    
    Reported-by: Keven Lachance
    Signed-off-by: Dave Airlie <airlied@redhat.com>

