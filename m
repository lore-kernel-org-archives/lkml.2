Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2HPPXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:23:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39620 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2HPPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:23:48 -0400
Message-ID: <502D1080.6070307@pobox.com>
Date: Thu, 16 Aug 2012 11:23:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] mvsas: fix a && vs & bug
References: <20120816110401.GA12318@elgon.mountain>
In-Reply-To: <20120816110401.GA12318@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 07:04 AM, Dan Carpenter wrote:
> The "1 << (slot_idx % 32)" condition is always true.  The intent was to
> test a bit field here using bitwise AND.  We do the test correctly a few
> lines later in the do while loop.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>



