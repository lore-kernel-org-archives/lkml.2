Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0KVPRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:17:47 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:60614 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277Ab0KVPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:17:45 -0500
Date: Mon, 22 Nov 2010 10:17:23 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <openosd@gmail.com>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nathan Laredo <laredo@gnu.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        Alessio Igor Bogani <alessioigorbogani@gmail.com>
Subject: Re: [PATCH 0/7] BKL removal follow-up
Message-ID: <20101122151723.GA8732@elliptictech.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Boaz Harrosh <openosd@gmail.com>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	Nathan Laredo <laredo@gnu.org>, Greg Kroah-Hartman <gregkh@suse.de>,
	Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	"J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
	Alessio Igor Bogani <alessioigorbogani@gmail.com>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
 <20101118233439.GB5004@quack.suse.cz>
 <AANLkTin0Gm8Xqm-ARGmd4T+fCM4mMA0=PbDA6eSsYUOG@mail.gmail.com>
 <4CE928DD.2010309@gmail.com>
 <AANLkTi=qvOHwgsbaCO6_Eu2Uik7MP5=C64+WW8R-RR8B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=qvOHwgsbaCO6_Eu2Uik7MP5=C64+WW8R-RR8B@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-21 09:45 -0800, Linus Torvalds wrote:
> Yes, I'd be ok with UDF doing a "select BKL" along with a "default n"
> for BKL itself.
> 
> I think UDF currently is the only sane reason to have BKL enabled any
> more, and yes, it would probably make it easier to configure things.

UFS (which I use) also relies on BKL.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
