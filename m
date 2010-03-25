Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab0CYVcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:32:17 -0400
Received: from c60.cesmail.net ([216.154.195.49]:58359 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0CYVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:32:15 -0400
Subject: [PATCH TRY2] locking: annotate inline spinlocks and rwlocks on SMP
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Josh Triplett <josht@us.ibm.com>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 17:32:14 -0400
Message-Id: <1269552734.2626.33.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

My patch at https://patchwork.kernel.org/patch/84441/ didn't get any
replies.

Bogus sparse warnings actually make developers change spin_lock() to
spin_lock_irqsave() to placate sparse, as it could be seen here:
http://marc.info/?l=linux-wireless&m=126954991321895&w=2

That's a patch I noticed because I read linux-wireless.  I think it's a
safe bet that it's not the only patch inspired by the bogus sparse
warnings.

Locking is hard already, and we don't want sparse to confuse developers
even more.  Linux code quality suffers because of that.

If there are any people or lists I should forward my patch to, please
let me know.

-- 
Regards,
Pavel Roskin
