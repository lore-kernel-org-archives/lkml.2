Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1I0KvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:51:04 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51224 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1I0KvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:51:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110923131819.fdaed4ab.akpm@google.com>
References: <20110919232602.ac450450.akpm00@gmail.com>
	<fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
	<20110923131819.fdaed4ab.akpm@google.com>
Date: Tue, 27 Sep 2011 13:51:00 +0300
Message-ID: <CAHp75VdJ+ZeVLPhb5R1_29k7cLWb9hFaMy+TS7HqioLiRm+8gQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel.h: rename pack_hex_byte to hex_pack_byte
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 11:18 PM, Andrew Morton <akpm@google.com> wrote:
> err, no thanks.  That's just going to hit everyone with great
> screenfuls of compile warnings while waiting for someone else to fix
> them up.

Okay, what about renaming pack_hex_byte to hex_byte_pack and
introducing temporary macro for backward compatibility?


-- 
With Best Regards,
Andy Shevchenko
