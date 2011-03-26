Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CZUEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:04:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58359 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1CZUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:04:23 -0400
Date: Sat, 26 Mar 2011 21:04:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
Message-ID: <20110326200419.GR21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org> <1300914043-2297-3-git-send-email-abogani@kernel.org> <m27hbov7hq.fsf@firstfloor.org> <8739mblr2n.fsf@rustcorp.com.au> <20110325154118.GN21838@one.firstfloor.org> <AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com> <20110325194946.GQ21838@one.firstfloor.org> <AANLkTinYY0vRzVHKqaZghiK=SvFUAVbM5s3Hf6H9C5Pv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinYY0vRzVHKqaZghiK=SvFUAVbM5s3Hf6H9C5Pv@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have felt sure to have sorted both: indeed the linker sorts symbols
> *before* it writes down their addresses (and not after). But I could
> have made a mistake, obviously.

I was refering to the address the symbol points to, not the address of
the ksymtab entry. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
