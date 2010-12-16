Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0LPO4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:56:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0LPO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:56:44 -0500
Date: Thu, 16 Dec 2010 15:49:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] blk-throttle: Some cleanups and race fixes in
	limit update code
Message-ID: <20101216144953.GA5227@redhat.com>
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com> <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292447255-10698-3-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Vivek Goyal wrote:
>
>         - Use xchg().
>         - Introduced a common function throtl_update_blkio_group_common()
>           which is shared now by all iops/bps update functions.

ACK

