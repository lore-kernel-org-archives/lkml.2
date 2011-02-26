Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1BZDV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 22:21:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1BZDV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:21:26 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=uQ12XBVAMdQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NR3QdbcfCVLs5OBs2joA:9 a=8VHHyIVG9jzoKeJaXqYA:7 a=PAlahZ0rh_er4JB6LKh9rLL6aCIA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Feb 2011 22:21:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, r@rostedt.homelinux.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Message-ID: <20110226032122.GA25737@home.goodmis.org>
References: <1298685930-30806-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298685930-30806-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Just an FYI,

When sending out patch series, could you send out a [PATCH 0/6] first,
and have all other patches a reply to that patch. Both git and quilt
have ways to do this.

The reason is that the linux kernel mailing list gets over 600 emails a
day, and for those of us that skim through, we like to hit [make thread
as read] when we are not interested in the thread or patch set. When
people send out a set of patches that are all individual, this means I
need to hit this command for every patch.

Also do not think I'm just picking on you. I've complained to several
people about doing this. One just recently sent out 21 patches.

Thanks,

-- Steve

