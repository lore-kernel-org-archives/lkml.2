Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2JVU4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:56:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60123 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291Ab2JVU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:56:28 -0400
X-Sasl-enc: +pW3Ia3ggYLDPNWEIJRhN7MNloM7aETHWPYvdCVrZtjx 1350939387
Date: Mon, 22 Oct 2012 13:56:26 -0700
From: Greg KH <greg@kroah.com>
To: Lauri Hintsala <lauri.hintsala@bluegiga.com>
Cc: SeongJae Park <sj38.park@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: csr: fix coding style
Message-ID: <20121022205626.GA4368@kroah.com>
References: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
 <507D08FE.4070902@bluegiga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507D08FE.4070902@bluegiga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 10:13:02AM +0300, Lauri Hintsala wrote:
> Hi,
> 
> On 10/15/2012 10:55 AM, SeongJae Park wrote:
> >Fix coding style of csr_framework_ext_types.h
> >
> >Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> >---
> >  drivers/staging/csr/csr_framework_ext_types.h |   33 +++++++++++--------------
> >  1 file changed, 15 insertions(+), 18 deletions(-)
> >
> >diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
> >index 57194ee..7e9cf8e 100644
> >--- a/drivers/staging/csr/csr_framework_ext_types.h
> >+++ b/drivers/staging/csr/csr_framework_ext_types.h
> >@@ -2,11 +2,11 @@
> 
> ...
> 
> >@@ -24,17 +24,15 @@ extern "C" {
> >
> >  #ifdef __KERNEL__
> >
> >-struct CsrThread
> >-{
> >-    struct task_struct *thread_task;
> >-    char                name[16];
> >+struct CsrThreadi {
> 
> 
> I think this extra i letter at the end of CsrThreadi string is typo.
> Did you try to compile the driver with your changes?

Turns out that no one uses 'struct CsrThread' anywhere, so this didn't
break the build.

But, it's incorrect, I'll fix it up by hand.

SeongJae, care to send a follow-on patch that just removes the whole
structure?

thanks,

greg k-h
