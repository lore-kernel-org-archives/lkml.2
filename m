Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0JAOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:09:29 -0400
Received: from trinity.fluff.org ([89.16.178.74]:36994 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab0JAOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:09:28 -0400
Date: Fri, 1 Oct 2010 15:09:18 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c fixes for 2.6.36
Message-ID: <20101001140918.GU21564@trinity.fluff.org>
References: <20101001140619.28d96040@endymion.delvare> <AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 10:38:46PM +0900, Kyungmin Park wrote:
> Hi Jean,
> 
> Even though it's not yet acked from Ben. It should be fixed for
> correct operation.
> Without this patch, some I2C device doesn't work correctly.
> http://www.spinics.net/lists/linux-i2c/msg04016.html

It was in my last pull request to Linus.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

