Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1KNG2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:28:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KNG2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:28:10 -0500
Message-ID: <1321252086.17837.56.camel@edumazet-laptop>
Subject: Re: [patch 0/7] timekeeping: Decouple xtime_lock from xtime seqcount
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Mon, 14 Nov 2011 07:28:06 +0100
In-Reply-To: <20111113230921.728083714@linutronix.de>
References: <20111113230921.728083714@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 novembre 2011 à 23:19 +0000, Thomas Gleixner a écrit :
> xtime_lock which serializes the update of time relevant data
> structures is held over a large code pathes which results in extended
> seqlock contention times on the reader side. This series decouples the
> lock from the seqcount and reduces the seqcount protected sections to
> those which actually update the reader visible data.
> 
> Thanks,

Thanks a lot Thomas, I'll take a look on this serie ASAP.



