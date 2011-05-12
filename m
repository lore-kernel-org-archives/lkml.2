Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1ELQCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:02:10 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46403 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757337Ab1ELQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:02:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Zz7Z3p4VM1kSe9IJ7dEI9T.b0KlM9DTGJuphhhVaJu_augi
 fd3k5ZAs1EiIxTcvp8Hwchu1w_8HKZBEBIBEF_CxKZ6KZVF6r8uZzVhJmM0B
 P2Jz.Wb6pXVSzBkkH8mYK_n.0GO_hPHvKzg4UpRN8slRJ54zvSJgS2k6SSMy
 yladf1fFm8nk4VC1kRca2aqWL9.ZfCPK1TTTF6lrQxWj.fzWAXpGdv0NjYbL
 gF8LPA_PbRBJoOkRGfYdUTD8TUJFmzLG1J9JpIGjUElijLftlcE4YPRADxMJ
 Io6xpcU63UoDfN.8Wx.Bqw1frknE82uhBHeeZ9Kk1srZg376QDpwnpxyamKn
 _VBoNlZXEf3PIGFnXZWv5QT8q
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 11:01:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305214993.2575.50.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105121050220.26013@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>  <1305127773-10570-4-git-send-email-mgorman@suse.de>  <alpine.DEB.2.00.1105120942050.24560@router.home>  <1305213359.2575.46.camel@mulgrave.site>  <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, James Bottomley wrote:

> > Debian and Ubuntu have been using SLUB for a long time
>
> Only from Squeeze, which has been released for ~3 months.  That doesn't
> qualify as a "long time" in my book.

I am sorry but I have never used a Debian/Ubuntu system in the last 3
years that did not use SLUB. And it was that by default. But then we
usually do not run the "released" Debian version. Typically one runs
testing. Ubuntu is different there we usually run releases. But those
have been SLUB for as long as I remember.

And so far it is rock solid and is widely rolled out throughout our
infrastructure (mostly 2.6.32 kernels).

> but a sample of one doeth not great testing make.
>
> However, since you admit even you see problems, let's concentrate on
> fixing them rather than recriminations?

I do not see problems here with earlier kernels. I only see these on one
testing system with the latest kernels on Ubuntu 11.04.
