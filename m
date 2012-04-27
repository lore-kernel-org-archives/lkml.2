Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab2D0Q4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:56:14 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44903 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760631Ab2D0Q4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:56:11 -0400
Message-ID: <4F9ACFC4.6010002@xenotime.net>
Date: Fri, 27 Apr 2012 09:56:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Subject: Re: inux-next: Tree for Apr 27 (infiniband/hw/ocrdma)
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
In-Reply-To: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 11:11 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120424:



when IPV6 is not enabled:

ERROR: "register_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!
ERROR: "unregister_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!




~Randy

