Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2BOL3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:29:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2BOL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:29:07 -0500
MIME-Version: 1.0
In-Reply-To: <4F3B17C7.9040107@ce.jp.nec.com>
References: <4EE8E419.8010000@pre-sense.de>
	<CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com>
	<20120214143800.69703df9@stein>
	<2173642.Y3HxI15Hxl@asus>
	<4F3B17C7.9040107@ce.jp.nec.com>
Date: Wed, 15 Feb 2012 12:29:06 +0100
X-Google-Sender-Auth: PiqF6Xv9Wt6jmru-CcIK62fbarg
Message-ID: <CAO+b5-rNF1R5NcSdVSsKLML4wyZBBGv-zUdq+B1y0kfHxLpupA@mail.gmail.com>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
From: Bart Van Assche <bvanassche@acm.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 3:26 AM, Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> I think this patch is good, too.
> Since QUEUE_FLAG_DEAD is also racy, it is not much different
> from queuedata check, IMO.

Are you sure ? As far as I know the block layer takes care of
synchronizing queue flag modifications against request_fn invocations.

Bart.
