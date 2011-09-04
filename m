Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1IDPFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:05:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1IDPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:05:30 -0400
Date: Sun, 4 Sep 2011 10:05:25 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Amit Shah <amit.shah@redhat.com>,
        David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?utf-8?B?TMO8YmJl?= <jluebbe@debian.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
Message-ID: <20110904150525.GE25587@elie>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110903221456.GA2877@elie>
 <20110904024244.GB3083@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904024244.GB3083@htj.dyndns.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Sat, Sep 03, 2011 at 05:14:56PM -0500, Jonathan Nieder wrote:

>> Various people[1] have been noticing a race (or races?) in which the
>> cdrom_id and scsi_id programs from udev can get stuck in the D state
[...]
> Can you please build vanilla kernel with CONFIG_FRAME_POINTER turned
> on, reproduce the problem and attach full dmesg output?

Thanks, Tejun.  I haven't been able to reproduce it here, but I'd be
happy to help anyone cc-ed wanting to do that who has questions (feel
free to email me privately).
