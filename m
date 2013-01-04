Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3ADXzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 18:55:53 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53950 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3ADXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 18:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOONJQ3cZCdE4GDJgtk6BdnS4En+uH8H2b_dPs3naujczBg@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
	<87k3rslg5a.fsf@xmission.com>
	<CAKocOOOXx+65rh4f8_++SwYMZdEO2FaOpLiW=dQ6uXZpwM1PYQ@mail.gmail.com>
	<CAE9FiQVpAfDb1_5TP=CqAQZQZKq=5AqQWo1NE3Sedijg+ML-gA@mail.gmail.com>
	<CAKocOONJQ3cZCdE4GDJgtk6BdnS4En+uH8H2b_dPs3naujczBg@mail.gmail.com>
Date: Fri, 4 Jan 2013 15:55:48 -0800
X-Google-Sender-Auth: pjB_fA6HI8qgwkOOirKQWc57wfo
Message-ID: <CAE9FiQXs5mC-oCpPWNVvQgn00LVbr70NqWtgaMVU088xSkkAqg@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 3:21 PM, Shuah Khan <shuahkhan@gmail.com> wrote:

> Please see attached dmesg for full log. I can do some testing on this
> system with your patch if you would like.

That would be great.

Please try
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot
or just this patch.

Too bad, I can not access AMD systems with IOMMU support.

Thanks a lot.

Yinghai
