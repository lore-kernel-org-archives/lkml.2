Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2L1IJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 03:09:50 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60962 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2L1IJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 03:09:48 -0500
Message-ID: <1356682190.19865.0.camel@gitbox>
Subject: Re: [PATCH 3/4] arm: vt8500: Convert debug-macro.S to be
 multiplatform friendly
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 21:09:50 +1300
In-Reply-To: <CABjd4Yx8CoREmQmJJjT9MO5Fr2Xr_mksGsofL8zBcS9DguAM6A@mail.gmail.com>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
	 <1356650452-16559-4-git-send-email-linux@prisktech.co.nz>
	 <CABjd4Yx8CoREmQmJJjT9MO5Fr2Xr_mksGsofL8zBcS9DguAM6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 10:21 +0600, Alexey Charkov wrote:
> 
> On Dec 28, 2012 3:21 AM, "Tony Prisk" <linux@prisktech.co.nz> wrote:
> >
> > This patch moves debug-macro.S from arm/mach-vt8500/include/mach to
> > arm/include/debug/vt8500.S to provide multiplatform support.
> 
> Hi Tony!
> 
> Looks like you haven't included the new file.
> 
> Best,
> Alexey
> 

Thanks Alexey,
Resent as 3/4 v2.

Regards
Tony P

