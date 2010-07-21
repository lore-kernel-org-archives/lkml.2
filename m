Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0GUMT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:19:56 -0400
Received: from verein.lst.de ([213.95.11.210]:51837 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0GUMTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:19:55 -0400
Date: Wed, 21 Jul 2010 14:19:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [xfs-masters] [PATCH] fs/xfs: Remove dead CONFIG_XFS_DMAPI
Message-ID: <20100721121904.GA17637@lst.de>
References: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 01:36:47PM +0200, Christian Dietrich wrote:
> CONFIG_XFS_DMAPI doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source
> code. Because XFS_DMAPI is never defined, XFS_DMAPI_STRING is always
> an empty string. So we can remove all references to it.

This code is already gone in the XFS queue for the next merge window.

