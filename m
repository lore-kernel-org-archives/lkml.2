Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0H0KgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:36:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0H0KgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:36:16 -0400
Date: Fri, 27 Aug 2010 12:36:20 +0200
From: Karel Zak <kzak@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to
	change_mnt_propagation()
Message-ID: <20100827103620.GC1844@nb.net.home>
References: <20100826200318.GA13636@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826200318.GA13636@shell>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:03:18PM -0400, Valerie Aurora wrote:
> shared/slave/private/unbindable mounts.  Karel Zak will fix the
> mount(8) bug shortly.

 Fixed, thanks for your bug report.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
