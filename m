Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0HJS3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:29:10 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:40804 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130Ab0HJS3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:29:05 -0400
Message-ID: <4C619A08.5050704@lougher.demon.co.uk>
Date: Tue, 10 Aug 2010 19:27:20 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org, x86@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: i386 allmodconfig, current mainline
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> fs/squashfs/xattr.c:37: warning: 'squashfs_xattr_handler' declared inline after being called
> fs/squashfs/xattr.c:37: warning: previous declaration of 'squashfs_xattr_handler' was here
> 

The fix for this is in linux-next, and it will be in my imminent 2.6.36 pull
request to Linus.

Phillip
