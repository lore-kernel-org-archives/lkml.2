Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1EMUDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:03:17 -0400
Received: from serv04.lahn.de ([213.239.197.57]:56741 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab1EMUDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:03:16 -0400
Date: Fri, 13 May 2011 21:54:13 +0200
From: Michael Leun <lkml20100708@newton.leun.net>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AHCI driver problem on ICH (Re: AHCI driver problem on
 SB700/SB800 w/ Acer Ferrari One)
Message-ID: <20110513215413.3480d6b5@xenia.leun.net>
In-Reply-To: <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
References: <201105120025.34531.rjw@sisk.pl>
	<20110513143758.33f68a77@xenia.leun.net>
	<201105131856.44250.rjw@sisk.pl>
	<BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 19:39:51 +0200
Tejun Heo <tj@kernel.org> wrote:

> Can you guys please take a look at bug#34692?  It seems to be the
> same problem.
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=34692
> 
> The offending commit seems to be 270dac35c2.  Does reverting it
> resolves the problem for you guys too?

- Does not happen with 2.6.38.6

- Happens 100% of cases with 2.6.39-rc7 (connect ac adapter or suspend
  to ram with ac connected and resume with ac disconnected)

- Reverting 270dac35c26433d06a89150c51e75ca0181ca7e4 fixes issue

-- 
MfG,

Michael Leun

