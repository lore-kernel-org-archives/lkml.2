Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1HHOlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:41:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42054 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1HHOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:41:13 -0400
Date: Mon, 8 Aug 2011 16:39:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 2/4] vfs: Introduce the fd closing helper
Message-ID: <20110808143942.GA22863@htj.dyndns.org>
References: <20110807210112.245578619@openvz.org>
 <20110807210526.994391865@openvz.org>
 <20110808095427.GA24017@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808095427.GA24017@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:54:27PM +0400, Cyrill Gorcunov wrote:
> On Mon, Aug 08, 2011 at 01:01:14AM +0400, Cyrill Gorcunov wrote:
> > From: Pavel Emelyanov <xemul@parallels.com>
> > 
> > This is nothing but making is possible to call the
> > sys_close from the kernel.
> > 
> > Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> 
> Drop this one for a while.

Yeah, I don't see why this would be necessary.

Thanks.

-- 
tejun
