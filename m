Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0CVTY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:24:58 -0400
Received: from fieldses.org ([174.143.236.118]:35820 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0CVTY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:24:57 -0400
Date: Mon, 22 Mar 2010 15:26:48 -0400
From: Bruce Fields <bfields@fieldses.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       =?utf-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Subject: Re: [Bug #15200] NFS problems in 2.6.33-rc6: Unknown error 526
Message-ID: <20100322192648.GM5359@fieldses.org>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.6nF.UQopLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hTwaxgnIZ2O.A.6nF.UQopLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 09:30:45PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).

This was dealt with by 260c64d23532caf19abb77e696971da05c388489.

--b.

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15200
> Subject		: NFS problems in 2.6.33-rc6: Unknown error 526
> Submitter	: J.A. Magallón <jamagallon@ono.com>
> Date		: 2010-01-31 22:46 (50 days old)
> References	: http://marc.info/?l=linux-kernel&m=126497800408928&w=4
> Handled-By	: Bruce Fields <bfields@fieldses.org>
> 
> 
