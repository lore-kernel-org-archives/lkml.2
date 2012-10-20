Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab2JTDrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 23:47:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18171 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2JTDq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 23:46:56 -0400
Date: Sat, 20 Oct 2012 06:46:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: Borislav Petkov <bp@alien8.de>, Chris Ball <cjb@laptop.org>,
        gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        Phil Turmel <philip@turmel.org>, sameo@linux.intel.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH v6 0/3] Add modules to support realtek PCIE card reader
Message-ID: <20121020034615.GT5685@mwanda>
References: <cover.1347330871.git.wei_wang@realsil.com.cn>
 <50664814.30407@turmel.org>
 <20120929110730.GA27797@liondog.tnic>
 <87d315osjm.fsf@octavius.laptop.org>
 <20120929152942.GA11412@liondog.tnic>
 <506FDC8C.3030707@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506FDC8C.3030707@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 03:23:56PM +0800, wwang wrote:
> We are still maintaining the SCSI driver for Realtek card reader,
> and will release the latest source code in the Github in the future.
> But maybe we won't push it to the staging tree any more.

Maybe we should just remove the staging code if it won't be fixed.
That's sort of the point of staging.

regards,
dan carpenter
