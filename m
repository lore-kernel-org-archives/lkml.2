Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2GXGfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:35:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48031 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2GXGfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:35:03 -0400
Date: Tue, 24 Jul 2012 09:34:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Chan <benchan@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Devendra Naga <devendra.aaru@gmail.com>
Subject: Re: [PATCH] staging: gdm72xx: fix reference counting in
 gdm_wimax_event_init
Message-ID: <20120724063445.GD4352@mwanda>
References: <1343084768-28803-1-git-send-email-benchan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343084768-28803-1-git-send-email-benchan@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 04:06:08PM -0700, Ben Chan wrote:
> This patch fixes commit 8df858ea76b76dde9a39d4edd9aaded983582cfe,

Please put the human readable patch title as well as just the hash.
Hashes sometimes change when they get merged into Linus's tree as
well.

> which
> mishandles the reference counting of wm_event.
> 

regards,
dan carpenter

