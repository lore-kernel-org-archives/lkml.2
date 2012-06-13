Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2FMMmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:42:06 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52195 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2FMMmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:42:03 -0400
Date: Wed, 13 Jun 2012 21:41:57 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        akpm@linux-foundation.org, bhutchings@solarflare.com,
        grundler@parisc-linux.org, arnd@arndb.de, benh@kernel.crashing.org,
        avi@redhat.com, mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net/ethernet/dec/tulip: Use standard
 __set_bit_le() function
Message-Id: <20120613214157.0a5179d5358ec7f1b2646606@gmail.com>
In-Reply-To: <CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
	<20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
	<CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 18:43:40 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Should this hash_table be converted from u16 hash_table[32] to
> DECLARE_BITMAP(hash_table, 16 * 32) to ensure that it is aligned
> on long-word boundary?

I think hash_table is already long-word aligned because it is placed
right after a pointer.

	Takuya
