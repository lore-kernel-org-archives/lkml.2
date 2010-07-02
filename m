Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0GBAm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:42:29 -0400
Received: from kroah.org ([198.145.64.141]:33292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0GBAm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:42:28 -0400
Date: Thu, 1 Jul 2010 17:37:58 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] drm/i915: fix hibernation since
 4bdadb9785696439c6e2b3efe34aa76df1149c83
Message-ID: <20100702003758.GA15055@kroah.com>
References: <1278029082-24223-1-git-send-email-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278029082-24223-1-git-send-email-airlied@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 10:04:42AM +1000, Dave Airlie wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Since 4bdadb9785696439c6e2b3efe34aa76df1149c83, we've been passing
> GFP_MOVABLE where we weren't before caused hibernate on Intel hardware
> to results in a lot of memory corruptions on resume.
> 
> [airlied: linus please enhance commit msg if you commit this]
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13811
> 
> Reported-by: Evengi Golov (in bugzilla)
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Tested-by: M. Vefa Bicakci <bicave@superonline.com>

This should go into .33 and .34-stable trees, right?

thanks,

greg k-h
