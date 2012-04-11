Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2DKGhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:37:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2DKGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:37:03 -0400
Date: Tue, 10 Apr 2012 23:37:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, "Luck, Tony" <tony.luck@intel.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] ramoops: use pstore interface
Message-Id: <20120410233731.7169c2e9.akpm@linux-foundation.org>
In-Reply-To: <CANGUGtAtHLe_5riSr-pMRyez9cTM6aUA5hir+-qr0zQLLjnGpg@mail.gmail.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	<4F1A7854.7010808@gmail.com>
	<1333399194.6431.3.camel@lorien2>
	<CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
	<20120409143345.a7a8c257.akpm@linux-foundation.org>
	<3908561D78D1C84285E8C5FCA982C28F170D020E@ORSMSX104.amr.corp.intel.com>
	<4F83F08E.6070304@gmail.com>
	<CAGXu5jLEn-+hnyz5DHxw9uMfN6Uo-=0mXsrhuvJ3WwQKki1nYg@mail.gmail.com>
	<CANGUGtAtHLe_5riSr-pMRyez9cTM6aUA5hir+-qr0zQLLjnGpg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 08:33:15 +0200 Marco Stornelli <marco.stornelli@gmail.com> wrote:

> I don't want to use a "veto" about this patch. If nobody see problem
> to apply it, then even ok for me. As I said I'm guessing possible
> situations where an unload features is useful.
> 
> Andrew what do you think?

Yes, I plan to send it to Linus.

breaking unloading is a regression, albeit a small one.  It's a bit
sad that nobody appears to intend to fix it.
