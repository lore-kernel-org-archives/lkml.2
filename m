Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1IUS5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:57:30 -0400
Received: from claw.goop.org ([74.207.240.146]:52232 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1IUS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:57:29 -0400
Message-ID: <4E7A3394.3090806@goop.org>
Date: Wed, 21 Sep 2011 11:57:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org> <alpine.DEB.2.00.1109211124050.8700@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1109211124050.8700@kaball-desktop>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 03:42 AM, Stefano Stabellini wrote:
> On Thu, 15 Sep 2011, Jeremy Fitzhardinge wrote:
>> This series is relying on regular ram mappings are already synced to all
>> tasks, but I'm not sure that's necessarily guaranteed (for example, if
>> you hotplug new memory into the domain, the new pages won't be mapped
>> into every mm unless they're synced).
> the series is using GFP_KERNEL, so this problem shouldn't occur, right?

What properties do you think GFP_KERNEL guarantees?

    J
