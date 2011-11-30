Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1K3WQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:16:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44963 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939Ab1K3WQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:16:08 -0500
Message-ID: <1322691367.10023.10.camel@Joe-Laptop>
Subject: Re: [PATCH 04/25] dynamic_debug: make dynamic-debug supersede DEBUG
 ccflag
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: jim.cromie@gmail.com, greg@kroah.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Nov 2011 14:16:07 -0800
In-Reply-To: <20111130220351.GC2500@redhat.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
	 <1322683014-13285-5-git-send-email-jim.cromie@gmail.com>
	 <20111130220351.GC2500@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 17:03 -0500, Jason Baron wrote:
> I think it's this patach that is causing a lot of "=p" when I boot up
> using a 'make defconfig'.

=p?

>  I'm a bit surprised at how many files have
> 'DEBUG' defined.

Also look for DDEBUG in Makefiles.

> Are we sure that we are setting the 'p' flag for the
> same set of debug statements that would be set if CONFIG_DYNAMIC_DEBUG
> were not set?

?

> Also, it seems a bit strange to me, if I now enable all debug statements
> and then clear everything (common pattern, I think), that I'm now
> disabling stuff that was enabled by default.

I don't think that's a common pattern and I
also don't think that's bad.


