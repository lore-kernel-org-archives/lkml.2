Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0HCEpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:45:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47138 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0HCEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:45:05 -0400
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 07:44:04 +0300
Message-ID: <1280810644.2542.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Aug 2010 04:44:57.0687 (UTC) FILETIME=[9FD87E70:01CB32C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-25 at 14:29 +0300, Artem Bityutskiy wrote:
> Hi,
> 
> here is v6 of the patch series which clean-ups bdi threads and substantially
> lessens amount of unnecessary kernel wake-ups, which is very important on
> battery-powered devices.
> 
> This patch-set is also available at:
> git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6

Ping

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

