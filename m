Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2K1Gkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 01:40:52 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43105 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2K1Gku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 01:40:50 -0500
Date: Wed, 28 Nov 2012 10:40:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch -mm 4/4] docs: Add documentation about
 /proc/<pid>/fdinfo/<fd> output
Message-ID: <20121128064048.GA3246@moon>
References: <20121122211522.075455799@openvz.org>
 <20121122212235.690256454@openvz.org>
 <20121127144754.5a617e12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127144754.5a617e12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:47:54PM -0800, Andrew Morton wrote:
> On Fri, 23 Nov 2012 01:15:26 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> >  Documentation/filesystems/proc.txt |   81 +++++++++++++++++++++++++++++++++++++
> 
> Looks good to me.  Here's a small tune-up:

Thanks a lot, Andrew!

	Cyrill
