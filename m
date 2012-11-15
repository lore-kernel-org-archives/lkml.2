Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767868Ab2KONuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:50:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32161 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767855Ab2KONuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:50:01 -0500
Message-ID: <50A4F2C2.9000401@parallels.com>
Date: Thu, 15 Nov 2012 17:48:50 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 2/7] fs, eventfd: Add procfs fdinfo helper
References: <20121114151937.344922058@openvz.org> <20121114152239.498171399@openvz.org>
In-Reply-To: <20121114152239.498171399@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This allow us to print out raw counter value.
> The /proc/pid/fdinfo/fd output is
> 
>  | pos:	0
>  | flags:	04002
>  | eventfd-count:               5a
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

Acked-by: Pavel Emelyanov <xemul@parallels.com>
