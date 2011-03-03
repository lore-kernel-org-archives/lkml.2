Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab1CCGlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:41:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337Ab1CCGlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:41:13 -0500
Date: Wed, 2 Mar 2011 22:40:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Rolland <rol@as2917.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: 2.6.37.2 : Font corruption and [drm:i915_gem_object_unbind]
 *ERROR* Attempting to unbind pinned buffer
Message-Id: <20110302224035.82d1cdd3.akpm@linux-foundation.org>
In-Reply-To: <20110228122608.1d6c759b@tux.DEF.witbe.net>
References: <20110228122608.1d6c759b@tux.DEF.witbe.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc dri-devel)


On Mon, 28 Feb 2011 12:26:08 +0100 Paul Rolland <rol@as2917.net> wrote:

> Hello,
> 
> I'm using 2.6.37.2 and I'm getting loads of this error in my messages,
> while at the same time I can observe font display corruption in a GTK
> application (Claws-Mail) while running X, compiz and this app.
> 
> I was previously using 2.6.36 and never experienced such a problem.
> 
> Video is :
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 
> I can provide additional information as needed (such a .config or details
> on userland env. if asked for precise details).
> 
> If this message warns about a badly acting userland, then why was it ok
> with 2.6.36 and the same userland env. ?
> 
> Best,
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
