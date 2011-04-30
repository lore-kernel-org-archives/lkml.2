Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1EBPvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:51:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49122 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116Ab1EBPvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:51:16 -0400
Date: Sat, 30 Apr 2011 19:45:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rcX problem continues
Message-ID: <20110430174501.GA2233@ucw.cz>
References: <web-514420100@zbackend1.aha.ru>
 <BANLkTinSRAz9FU3LyiiTBduyqyusX9f5rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinSRAz9FU3LyiiTBduyqyusX9f5rg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-04-28 16:08:00, Am?rico Wang wrote:
> On Thu, Apr 28, 2011 at 6:35 AM, werner <w.landgraf@ru.ru> wrote:
> > I inform that the reported problem of crashs some minutes until hours after
> > booting, during moving or zip/unzip big files, what I would guess to be a
> > problem of the memory administration, continues with 2.6.39-rc5 .   This at
> > least for me and friends is the main reason why 2.6.39-rc5 cannot be used
> > normally and one have to use 2.6.38.4 where this problem don't happens.
> >
> 
> Please report the bug with more details, otherwise no one can help. :)

Shell script that reproduces it would be nice. And cc: rafael,
regressions maintainer.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
