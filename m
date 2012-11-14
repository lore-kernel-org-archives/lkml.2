Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2KNJVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:21:09 -0500
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:49698 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab2KNJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:21:07 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
Date: Wed, 14 Nov 2012 09:20:51 +0000
Message-ID: <4242534.oR1fYvhZDe@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20121113152846.GJ7808@moon>
References: <20121112101440.665694060@openvz.org> <2176466.A8PC9hQJK4@deuteros> <20121113152846.GJ7808@moon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 19:28:46 Cyrill Gorcunov wrote:
> On Tue, Nov 13, 2012 at 03:02:22PM +0000, Tvrtko Ursulin wrote:
> > Perhaps there could be a different way, where you could use additional
> > space only when it is actually used at runtime. But as I said, I am not
> > following closely.
> 
> Unfortunatelly at moment I see no way how to make it in on-demand fashion.

You could not use a pointer and then allocate your buffers on the check point 
operation, freeing on restore?

Regards,

Tvrtko

