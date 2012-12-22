Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2LVUV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 15:21:58 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:60830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 15:21:56 -0500
Message-ID: <1356207733.10280.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 14/25] rfkill: don't use [delayed_]work_pending()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Date: Sat, 22 Dec 2012 21:22:13 +0100
In-Reply-To: <1356141435-17340-15-git-send-email-tj@kernel.org> (sfid-20121222_030236_218242_05D0330F)
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	 <1356141435-17340-15-git-send-email-tj@kernel.org>
	 (sfid-20121222_030236_218242_05D0330F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 17:57 -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from rfkill.  Only compile
> tested.

Looks fine to me, feel free to route through your tree -- nobody changes
rfkill much (famous last words...) :-)

johannes

