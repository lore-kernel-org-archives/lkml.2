Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab1DYKtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:49:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51725 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab1DYKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZhcCabW/Ik0/zOF3HBlu27F3yN/ZSP8/cRk1ba6zCeyXkfmbtcSFJDkL4Y+vh+QeAc
         VPXZHtS/0zd+jowmNHWPmD218ByZ5JytmDpl3PNFNy6/m4Mf9fSCVtOZuZ0b+N/3R5J/
         kUqDI6lfAGy1qiU2B4FBO+MwnOJDjrmY8/hF0=
Date: Mon, 25 Apr 2011 12:49:12 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] signal: introduce retarget_shared_pending()
Message-ID: <20110425104912.GD17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134443.GB15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134443.GB15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:44:43PM +0200, Oleg Nesterov wrote:
> No functional changes. Move the notify-other-threads code from exit_signals()
> to the new helper, retarget_shared_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
