Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2DGBC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:02:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2DGBCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com> <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 6 Apr 2012 18:02:04 -0700
X-Google-Sender-Auth: PNAA4VrsMUXnmxnQ7E3xR1AgTX8
Message-ID: <CAB=NE6Uf2cvhLcS4+Nu4j0DvorOZJJR1pWOKteTbQuHan07nng@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 5:51 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:

> 4) Use the patch and leave it to the person who wants to extract code
> to figure out the exact module license.

After some though I think this is the only approach possible. Consider
ath5k which has files under difference licenses:

  * Dual BSD/GPL
  * GPL
  * ISC

The person taking code must check the header of each file.

  Luis
