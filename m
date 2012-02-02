Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2BBTdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:33:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab2BBTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:33:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM/Suspend: Avoid code duplication in suspend statistics update
Date: Thu, 2 Feb 2012 20:37:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328146776-1766-1-git-send-email-marcos.mage@gmail.com> <4F29EBED.6060006@linux.vnet.ibm.com>
In-Reply-To: <4F29EBED.6060006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202022037.19225.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 02, 2012, Srivatsa S. Bhat wrote:
> On 02/02/2012 07:09 AM, Marcos Paulo de Souza wrote:
> 
> > The code
> >        if (error) {
> >                suspend_stats.fail++;
> >                dpm_save_failed_errno(error);
> >        } else
> >                suspend_stats.success++;
> > 
> > Appears in the kernel/power/main.c and kernel/power/suspend.c.
> > 
> > This patch just creates a new function to avoid duplicated code.
> > 
> > Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> > ---
> 
> 
> Looks good to me :-)
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied.

Thanks,
Rafael
