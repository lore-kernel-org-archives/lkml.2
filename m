Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab0G2UGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0G2UGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:06:51 -0400
Date: Thu, 29 Jul 2010 22:06:46 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
Message-ID: <20100729200646.GG1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> <20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> <20100729195616.GF1981@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729195616.GF1981@nb.net.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 09:56:16PM +0200, Karel Zak wrote:
> BTW, why there is /sys/block/loopN at all if the device
> is not associated with any backing file?

 ignore this question ;-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
