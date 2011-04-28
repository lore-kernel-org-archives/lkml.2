Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1D1X5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:57:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43301 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab1D1X5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type;
        b=Pwnkkyhicod9pTdpGNWeru9fVQGedImGZGwfq+utNMKyyDN6h+wEt+aTROe8gZZP1d
         2kqGxhj+2yW0ax0TKirznpxOH6+q8ahJBWap2SsH0dV+C59uwJn7x3WlgpHsHdFsAyYu
         aH0QzI4J3Nbby9XSfPKVcMe9FHMAUIipJPYCE=
MIME-Version: 1.0
X-Originating-IP: [91.17.222.55]
In-Reply-To: <20110428103036.GB10721@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de> <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org> <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
 <20110428103036.GB10721@htj.dyndns.org>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Fri, 29 Apr 2011 01:56:46 +0200
Message-ID: <BANLkTinK3jZmKewkbtmOn54cRXhszh_5sQ@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
To: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:30, Tejun Heo <tj@kernel.org> wrote:
> Does your kernel have preemption enabled?

CONFIG_PREEMPT is not set

> If not, does the following patch fix the problem?

Yep, looks good so far (at least in my virtualized test environment):
2.6.39-rc4 with your patch applied survived 100 suspend/resume cycles
w/o locking up.

Just out of curiosity: Was this a new issue in 2.6.39-rc4 ord could
this fix be backported to 2.6.38?

Thanks,
Thilo
