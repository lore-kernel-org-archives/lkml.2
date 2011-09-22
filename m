Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1IVQFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:05:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37795 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751219Ab1IVQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:05:30 -0400
Subject: Re: Hyper-V TODO file
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Date: Thu, 22 Sep 2011 09:05:28 -0700
In-Reply-To: <1316708240-25048-1-git-send-email-kys@microsoft.com>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316707529.21302.3.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 09:17 -0700, K. Y. Srinivasan wrote:
> With your last checkin of the patches for Hyper-V, I have addressed all of 
> the issues you had raised as part of the vmbus audit. Should I send you a 
> patch to update the TODO file to reflect this. Let me know.

Is there really anything left to do but send
the patch that moves hv out of staging?


