Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HHOkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:40:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55736 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1HHOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:40:39 -0400
Date: Mon, 8 Aug 2011 16:40:35 +0200
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 3/4] proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20110808144035.GB22863@htj.dyndns.org>
References: <20110807212031.GG2080@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110807212031.GG2080@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:20:31AM +0400, Cyrill Gorcunov wrote:
> From: Pavel Emelyanov <xemul@parallels.com>
> 
> Although we can get the pids of some task's issue, this is just 
> more convenient to have them this way.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

I'm not necessarily against this one but don't really see much point
either.  Can we delay this for now?

Thanks.

-- 
tejun
