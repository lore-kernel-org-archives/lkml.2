Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1FXXDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 19:03:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1FXXC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 19:02:58 -0400
References: <20110623133740.0cdaf204@jbarnes-desktop> <BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com> <20110624085318.70bde05c@jbarnes-desktop> <BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com> <20110624091148.18f8959d@jbarnes-desktop>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110624091148.18f8959d@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [git pull] PCI fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Jun 2011 15:56:42 -0700
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>, yinghai@kernel.org
Message-ID: <204d042e-86c0-41a5-80f0-e04d6b7adf25@email.android.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Fri, 24 Jun 2011 23:02:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>How about a boot param?  We've done similar things for _CRS, and it
>might give Yinghai and Ram some more flexibility in improving our
>dynamic resource allocation before enabling it again (if ever).

I'm OK with that, but then I'd suggest against the currently not yet merged series that doesn't seem to work anyway...

IOW, just a simple patch that disables the resource re-allocation, and enables it with some command line option.

         Linus
