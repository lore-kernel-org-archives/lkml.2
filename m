Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2DYAOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:14:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48853 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2DYAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:14:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F974161.1060105@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 09:12:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH -mm] c/r: prctl: Return -EFAULT instead of -EINVAL in
 case if underlied VMA is not found
References: <20120424200813.GK21224@moon>
In-Reply-To: <20120424200813.GK21224@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 5:08), Cyrill Gorcunov wrote:

> In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
> but Michael proposed to return -EFAULT and Kosaki seconded.
> Make it so.
> 
> Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>,
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


