Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2GYTmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:42:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:33690 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2GYTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:42:20 -0400
Message-ID: <50104C0A.8050607@windriver.com>
Date: Wed, 25 Jul 2012 15:42:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        James Bottomley <JBottomley@parallels.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] firmware: Remove obsolete Myricom firmware
References: <1343237441-102862-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1343237441-102862-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-07-25 01:30 PM, Tim Gardner wrote:
> The Myricom GB driver firmware is no longer in use. Furthermore,
> CONFIG_MYRI_SBUS is no longer defined.

If there is going to be more of these, it is kind of nice to
have in the commit header a reference to the commit when the
original user(s) went away.

In this case, it was:

---
commit 1b9c4134c126aa8ae00a57672d4a4eaecc436b54
Author: Jon Mason <mason@myri.com>
Date:   Mon Jun 20 12:51:22 2011 -0700

    myri_sbus: remove driver
    
    Remove the myri_sbus driver. Why?
    * There is no possibility of ethernet mode on this adapter, so it's
      Myrinet only.
    * It won't inter-op with modern versions of Myrinet, and thus can only
      work with legacy adapters.
    * There are no in-kernel Linux drivers for the PCI version of this
      adapter, so it only can work on ~15 year old Sun hardware.
    
    It's long in the tooth, let's take it to the knackers.
    
    Signed-off-by: Jon Mason <mason@myri.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
----

Thanks,
Paul.

> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
