Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0I3BCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:02:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38266 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0I3BCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:02:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: William Immendorf <will.immendorf@gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTiknh_oVCtaUzcH8rh5XdORm-Pb83z22_zPB_4pO@mail.gmail.com>
References: <20100927120641.6B3F.A69D9226@jp.fujitsu.com> <AANLkTiknh_oVCtaUzcH8rh5XdORm-Pb83z22_zPB_4pO@mail.gmail.com>
Message-Id: <20100930095339.2A7F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 30 Sep 2010 10:02:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Sep 26, 2010 at 10:04 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> This is a backport of Upstream commit e31f3698cd3499e676f6b0ea12e3528f569c4fa3.
> >> Originally submitted by Wu Fengguang. The rest of the message is his.
> >> I think this would be a good canadate for the stable tree.
> >
> > We already did :)
> I really meant for this patch to reach the stable tree. KOSAKI, can
> you please email the stable tree mantianer and tell him to put this
> patch in a 2.6.35.7 stable quere? (and also tell me the stable commits
> address for refrence.)

Hi

AFAIK, Greg apply it to his stable tree. but I'm not sure it's already released or not.

http://kerneltrap.org/mailarchive/linux-kernel/2010/8/23/4610133



