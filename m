Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0IJKNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:13:09 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43678 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0IJKNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:13:08 -0400
Message-ID: <4C8A04B3.4030406@kernel.dk>
Date: Fri, 10 Sep 2010 12:13:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Subject: Re: [PATCH 00/13] cciss: clean up cciss_ioctl()
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-26 20:55, Stephen M. Cameron wrote:
> This series of patches factors out all of cases of the giant
> switch statement in cciss_ioctl into separate functions.  And
> there's one patch at the end that gets rid of some superfluous
> if statements in the big passthru path.
> 
> I've run test programs that exercise all these ioctls and they
> appear to still work.
> ---
> 
> Stephen M. Cameron (13):
>       cciss: factor out cciss_getpciinfo
>       cciss: factor out cciss_getintinfo
>       cciss: factor out cciss_setintinfo
>       cciss: factor out cciss_getnodename
>       cciss: factor out cciss_setnodename
>       cciss: factor out cciss_getheartbeat
>       cciss: factor out cciss_getbustypes
>       cciss: factor out cciss_getfirmver
>       cciss: factor out cciss_getdrivver
>       cciss: factor out cciss_getluninfo
>       cciss: factor out cciss_passthru
>       cciss: factor out cciss_big_passthru
>       cciss: remove some superfluous tests from cciss_bigpassthru()

Thanks, applied to for-2.6.37/drivers

-- 
Jens Axboe

