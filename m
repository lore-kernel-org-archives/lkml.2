Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1DDUIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:08:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49964
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339Ab1DDUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:08:16 -0400
Date: Mon, 04 Apr 2011 13:07:39 -0700 (PDT)
Message-Id: <20110404.130739.209975217.davem@davemloft.net>
To: ostr@amd64.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com
Subject: Re: [PATCH] ipv6: Don't pass invalid dst_entry pointer to
 dst_release().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301946910-5530-1-git-send-email-ostr@amd64.org>
References: <1301946910-5530-1-git-send-email-ostr@amd64.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <ostr@amd64.org>
Date: Mon,  4 Apr 2011 15:55:10 -0400

> From: Boris Ostrovsky <boris.ostrovsky@amd.com>
> 
> Make sure dst_release() is not called with error pointer. This is
> similar to commit 4910ac6c526d2868adcb5893e0c428473de862b5.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>

Applied, thank you.
