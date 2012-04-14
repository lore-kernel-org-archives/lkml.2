Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2DNVo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:44:59 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39605 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab2DNVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:44:57 -0400
Subject: Re: [PATCH 0/2] sbp-target: cleanup after merge into single file
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de
In-Reply-To: <1334394746-31738-1-git-send-email-bootc@bootc.net>
References: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
	 <1334394746-31738-1-git-send-email-bootc@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Apr 2012 14:44:55 -0700
Message-ID: <1334439895.12540.65.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 10:12 +0100, Chris Boot wrote:
> Thanks to Nick Bellinger for doing the work for me and merging the
> sbp-target code into single source/header files. This little series
> does a bit of cleanup and updates the TODO file.
> 
> I'll also take this opportunity to add my sign-off to Nick's patch that
> merges everything together, which this series is on top of:
> 
> 	Acked-by: Chris Boot <bootc@bootc.net>
> 

Thanks for the Ack.  ;)

I'll go ahead and merge the sbp-merge branch back into lio-core/master
now, and apply this series on top of master.

Also, it looks like Stefan has a few more comments from the last round
of review..  I'll go ahead and get the latest HEAD prepped for
target-pending today, and plan to rebase any forthcoming incremental
patches from you into a single merge commit in target-pending.

Thanks Chris!

--nab

