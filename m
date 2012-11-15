Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767922Ab2KONum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:50:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:18145 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767793Ab2KONuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:50:39 -0500
Message-ID: <50A4F2EB.2020109@parallels.com>
Date: Thu, 15 Nov 2012 17:49:31 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 4/7] fdinfo: Show sigmask for signalfd fd v3
References: <20121114151937.344922058@openvz.org> <20121114152239.674555420@openvz.org>
In-Reply-To: <20121114152239.674555420@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 07:19 PM, Cyrill Gorcunov wrote:
> The sigmask is read in lockless manner for a sake of
> code simplicity, thus if precise data needed here
> the tasks which refer to the signalfd should be
> stopped before read.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: James Bottomley <jbottomley@parallels.com>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Matthew Helsley <matt.helsley@gmail.com>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> ---
>  fs/proc/array.c         |    2 +-
>  fs/signalfd.c           |   18 ++++++++++++++++++
>  include/linux/proc_fs.h |    3 +++
>  3 files changed, 22 insertions(+), 1 deletion(-)


Acked-by: Pavel Emelyanov <xemul@parallels.com>
