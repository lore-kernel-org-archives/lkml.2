Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0G3HhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0G3HhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:37:09 -0400
Date: Fri, 30 Jul 2010 09:37:04 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
Message-ID: <20100730073704.GH1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> <20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 06:07:31PM +0200, Kay Sievers wrote:
> Sure it does. Sysfs attributes need to be created _before_ uevents are
> sent out. The current behavior is that all blockdev attributes are
> safely created before the event is sent.

 Hmm... I see that in add_disk(), the "queue" subdirectory is created
 after disk registration (the register_disk() calls kobject_uevent()).
 Is it true?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
