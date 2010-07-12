Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0GLNmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:42:09 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:43976 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab0GLNmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:42:07 -0400
Message-ID: <4C3B1BAC.1050907@msgid.tls.msk.ru>
Date: Mon, 12 Jul 2010 17:42:04 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com> <4C3ABF96.9070405@msgid.tls.msk.ru> <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com> <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
In-Reply-To: <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik wrote:
[]
> O_DIRECT support was just introduced recently, please try on the latest kernel
> with the normal settings (which IIRC uses O_DIRECT), that should make things
> suck alot less.  Thanks,

Um.  Do you mean it were introduced in BTRFS or general? :)

Because, wel, O_DIRECT is here and supported since some 2.2 times... ;)

/mjt
