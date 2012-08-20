Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2HTQdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:33:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40872 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab2HTQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:33:43 -0400
Date: Mon, 20 Aug 2012 20:33:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120820163338.GN23596@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <87fw7habo4.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw7habo4.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 07:49:23PM +0530, Aneesh Kumar K.V wrote:
> Cyrill Gorcunov <gorcunov@openvz.org> writes:
> 
> > To provide fsnotify object inodes being watched without
> > binding to alphabetical path we need to encode them with
> > exportfs help. This patch adds a helper which operates
> > with plain inodes directly.
> 
> doesn't name_to_handle_at()  work for you ? It also allows to get a file
> handle using file descriptor.

Hi, sorry for dealy. Well, the last idea is to get rid of this helper,
I've sent out an updated version where ino+dev is only printed.

	Cyrill
