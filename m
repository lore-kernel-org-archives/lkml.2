Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0GVTIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:08:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:08:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=WfULKuUGNWzzB8vmn4AEo0pjtkC9Us/OhgH5kHOOoMy3mdexSDoz5oe/rBpesxcAY
	jszZmCDMOPL6MmqSPa8xg==
MIME-Version: 1.0
In-Reply-To: <20100722185301.GA528@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
	<20100722185301.GA528@suse.de>
Date: Thu, 22 Jul 2010 12:07:43 -0700
Message-ID: <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:53 AM, Greg KH <gregkh@suse.de> wrote:
>
> If you are using /dev/cgroup/ that's nice, but I don't think that people
> are expecting a whole filesystem under a /dev/ subdirectory.

Sure - as I said that's just for historical reasons from when we
migrated from cpusets which were traditionally mounted at /dev/cpuset,
so it involved less change. There's no particular reason to mount it
there (although having said that, what about /dev/pts and /dev/shm?).

Paul
