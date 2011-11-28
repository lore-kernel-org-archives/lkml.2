Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1K1Git (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:38:49 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:38591 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1K1Gis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:38:48 -0500
Subject: Re: [PATCH] iscsi-target: Use kmemdup rather than duplicating its
 implementation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1321569820.1624.298.camel@localhost.localdomain>
References: <1321569820.1624.298.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Nov 2011 22:38:45 -0800
Message-ID: <1322462325.20311.465.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 23:43 +0100, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Hi Thomas,

My apologies for the delayed response.  This patch has been applied to
lio-core.git, and will be included for the v3.3 merge.

Thanks!

--nab

