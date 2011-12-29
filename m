Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1L2DzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:55:04 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:34380 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1L2DzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:55:01 -0500
Message-ID: <1325130899.2029.18.camel@shrek.rexursive.com>
Subject: Re: [PATCH] PM / Hibernate: Improve performance of LZO/plain
 hibernation, checksum image
From: Bojan Smojver <bojan@rexursive.com>
To: Barry Song <21cnbao@gmail.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Date: Thu, 29 Dec 2011 14:54:59 +1100
In-Reply-To: <CAGsJ_4x2yCNf48xnVzBCZLJhdUaAOfoNHx5AFamZMXgLZ0PEKw@mail.gmail.com>
References: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
	 <1325115628.2029.1.camel@shrek.rexursive.com>
	 <CAGsJ_4xH-9MXq8UJJFLW=upBqK+PXbWfDJhttBN=n2_M0PzMSw@mail.gmail.com>
	 <1325127531.2029.13.camel@shrek.rexursive.com>
	 <CAGsJ_4x2yCNf48xnVzBCZLJhdUaAOfoNHx5AFamZMXgLZ0PEKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-29 at 11:20 +0800, Barry Song wrote:
> the platform is ARM cortex-a9 single-core 1Ghz SoC and we save image
> to a SD card or NAND.
> a phenomenon we saw is that multi-BIOs is not merged into a request by
> block level elevator. so the SD/NANDdisk driver handles many small
> request one page by one page. 

Interesting, thanks.

-- 
Bojan

