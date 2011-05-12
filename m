Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1ELSDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:03:13 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:46122 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932348Ab1ELSDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:03:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Se46MwEVM1nOerG7f1F2sjQu27TTrQQSCLqA30N4YuE.Sfd
 nWGFxY3M0s6KWAe0kfRA1uTsUSwObPfhd72q.Fv2UAQW3ZqoMiKYpYHuhnhl
 cQn46ISQqsRUcqh4vO.XGGHyQBxIb2qsR3sVxMzn1vco2bqvZIFd6GPz13h4
 bXUPuZ8K5buKh.qLpguYWiMQyu3D5WakeyyUTypL50LMHO4Ru_RxQjv46JJ0
 wj6lEeJPrJ6pG1fAs4uDRKu1OsxQbMlOdCMbu3IWytyE7JtU7gwCGaHVREAT
 DpQbFs9.ru6o2eq4SEVmOMm3jkQ_iscFGekXlLeRbqjMqIUSdMBC__KRua.H
 ewDbKHK6Cfaz6aQq.eXFfcpSy
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 13:03:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <20110512175104.GM11579@random.random>
Message-ID: <alpine.DEB.2.00.1105121302240.28493@router.home>
References: <alpine.DEB.2.00.1105120942050.24560@router.home> <1305213359.2575.46.camel@mulgrave.site> <alpine.DEB.2.00.1105121024350.26013@router.home> <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com> <1305216023.2575.54.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121121120.26013@router.home> <1305217843.2575.57.camel@mulgrave.site> <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com> <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com> <20110512175104.GM11579@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Andrea Arcangeli wrote:

> even order 3 is causing troubles (which doesn't immediately make lumpy
> activated, it only activates when priority is < DEF_PRIORITY-2, so
> after 2 loops failing to reclaim nr_to_reclaim pages), imagine what

That is a significant change for SLUB with the merge of the compaction
code.
