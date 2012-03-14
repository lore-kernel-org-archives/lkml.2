Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2CNIeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:34:03 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61845 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2CNId5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:33:57 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325462400"; 
   d="scan'208";a="11280179"
Message-ID: <1331714035.4092.4.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/blkback: Squash the discard support for
 'file' and 'phy' type.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Li Dongyang <lidongyang@novell.com>
Date: Wed, 14 Mar 2012 08:33:55 +0000
In-Reply-To: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
References: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 22:52 +0000, Konrad Rzeszutek Wilk wrote:
> The only reason for the distinction was for the special case of
> 'file' (which is assumed to be loopback device)

Not related to this patch but how feasible would it be to make blkback
able to cope with files directly?

Ian.

