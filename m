Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab2EJPED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848Ab2EJPEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:04:00 -0400
Date: Thu, 10 May 2012 11:03:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Subject: Re: [dm-devel] [Bcache v13 00/16]
Message-ID: <20120510150353.GI23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:

[..]
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.
> 

Ok, I missed above lines and was pointed to it. So idea of this posting is
to review core changes and then somebody else needs to take the core, wrap
it with dm apis and repost?

Thanks
Vivek
