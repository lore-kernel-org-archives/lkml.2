Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2FZRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:48:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60981 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2FZRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:48:47 -0400
Message-ID: <4FE9F5FD.2000007@tilera.com>
Date: Tue, 26 Jun 2012 13:48:45 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/12] tile: remove km_type definitions
References: <1340445863-16111-1-git-send-email-amwang@redhat.com> <1340445863-16111-9-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-9-git-send-email-amwang@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/2012 6:04 AM, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  arch/tile/include/asm/kmap_types.h |   26 --------------------------
>  1 files changed, 0 insertions(+), 26 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Looks like it almost works today, except for fs/jbd2/commit.c, at least
using the config I tried.  But I see you have a change for that pending.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



