Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0DVPU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab0DVPUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:20:55 -0400
Date: Thu, 22 Apr 2010 11:20:50 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: Kees Cook <kees@canonical.com>
Cc: Kyle McMartin <kmcmartin@redhat.com>, eparis@redhat.com,
       cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: make mmap_min_addr perms 600
Message-ID: <20100422152050.GB8389@ihatethathostname.lab.bos.redhat.com>
References: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
 <20100421182911.GB13524@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421182911.GB13524@outflux.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:29:11AM -0700, Kees Cook wrote:
> I would opt for greater transparency for the admin, and leave it 644 and
> instead more carefully check CAP_SYS_RAWIO.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

fine with me.
