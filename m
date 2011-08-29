Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1H2Pim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:38:42 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:52964 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1H2Pil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:38:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume support to drbd
Date: Mon, 29 Aug 2011 17:38:33 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: Kyle Moffett <kyle@moffetthome.net>, drbd-dev@lists.linbit.com,
        Greg Freemyer <greg.freemyer@gmail.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com> <201108291351.06092.philipp.reisner@linbit.com> <CAOJsxLHQFhHaASj9eSJeQ9H_VyS59ztu=caOoUipYEneiB1vAA@mail.gmail.com>
In-Reply-To: <CAOJsxLHQFhHaASj9eSJeQ9H_VyS59ztu=caOoUipYEneiB1vAA@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291738.33747.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. August 2011, 14:52:56 schrieb Pekka Enberg:
> On Mon, Aug 29, 2011 at 2:51 PM, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > The new feature set, might be partially broken, but introducing
> > the new features is the whole point of this patch series.
> 
> If that new feature can, for example, corrupt your data while you're
> doing "git bisect" on non-DRBD regression, that's no good. Can that
> happen?
> 

No, that can not happen. Maybe it fails to connect to the peer, etc...
It will not destroy data.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
