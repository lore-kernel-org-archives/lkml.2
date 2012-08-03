Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2HCQa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:30:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2HCQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:30:25 -0400
Message-ID: <1344011416.4482.11.camel@jlt3.sipsolutions.net>
Subject: Re: [REGRESSION][v3.5] iwlwifi: include rssi as part of decision
 making for reduce txpower
From: Johannes Berg <johannes@sipsolutions.net>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com, linville@tuxdriver.com,
        emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Aug 2012 18:30:16 +0200
In-Reply-To: <501BFB29.7010801@canonical.com> (sfid-20120803_182456_195468_6BBC5170)
References: <501BFB29.7010801@canonical.com>
	 (sfid-20120803_182456_195468_6BBC5170)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 12:24 -0400, Joseph Salisbury wrote:

> A test kernel was created with this commit reverted, which stopped the 
> kernel panic from occurring.
> 
> A bugzilla bug[1] has been opened.

> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1029547
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=45491

This is a duplicate of https://bugzilla.kernel.org/show_bug.cgi?id=45481
which I've already commented on with the correct fix. I've also sent the
fix to stable:

http://www.mail-archive.com/stable@vger.kernel.org/msg12286.html

Thanks,
johannes

