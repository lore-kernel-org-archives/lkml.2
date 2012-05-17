Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab2EQQcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:32:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25313 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab2EQQcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:32:10 -0400
Message-ID: <4FB52804.8090004@parallels.com>
Date: Thu, 17 May 2012 20:32:04 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 2/4] procfs: Convert /proc/pid/fdinfo/fd handling routines
 into seq-file with fdinfo helpers
References: <20120517160738.116113099@openvz.org> <20120517162534.681059644@openvz.org>
In-Reply-To: <20120517162534.681059644@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 08:07 PM, Cyrill Gorcunov wrote:
> This patch converts /proc/pid/fdinfo/fd handling routines to seq-files with
> ability to plug in additional fdinfo helpers from other subsystems.
> 
> For example files created in eventfd/eventpoll/inotify subsystems might print
> out additional information, not just file position and flags.
> 
> Still if there no fdinfo helpers registered then the output is well known
> pos, flags pair.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

I would split this into two parts -- the 1st one turns fdinfo into seq-files
and the 2nd one adds the fdinfo helpers. This will make the review MUCH simpler.

Thanks,
Pavel

