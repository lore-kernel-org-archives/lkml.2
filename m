Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0IEBro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:47:44 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21875 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754348Ab0IEBrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:47:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RwayEekVM1lcLQI2Ou7gpOm7ksy8KF8fYmlzeYfQAwN.qpG
 GPLakM8kPTpXYs.1enqncmUPnHuP6a7jJvWB3JKgu4LnS3sEgk2EepLUGILq
 dKtuYyDR0s1bH04xqN3UYYoEvRtKtlHcjs0KImq22nqGhg4JhqZaxhgNxa8t
 4ueYuPzxqvjopFaAtfQhElu80YjdHwRqY3IOkUmX1vNPQShTVepunFq35REa
 y6VS2FofKbliw.J_lIXFz5soizHWdlb0V
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 4 Sep 2010 20:47:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Christian Riesch <christian.riesch@gmail.com>
cc: Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
In-Reply-To: <4C828652.4060804@gmail.com>
Message-ID: <alpine.DEB.2.00.1009042042130.9425@router.home>
References: <cover.1283504065.git.richard.cochran@omicron.at> <alpine.DEB.2.00.1009041221240.888@router.home> <4C828652.4060804@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Christian Riesch wrote:

> Richard's idea is to support clock hardware for IEEE 1588 (PTP, Precision Time
> Protocol). Have a look at the earlier discussions:
>
> http://lkml.org/lkml/2010/8/16/90

A superficial scan does not give me any definite agreement on an approach.
The patchset also needs to be CCed to John Stultz. Without a summary I
still am not clear what this is supposed to address.

Tuning of the PTP clock can be done with driver specific configuration
rather than a new POSIX clock. That is at least how SGI_CYCLE is operating
which is similar.

> http://lkml.org/lkml/2010/8/23/49

Ok this goes more into something that may prove useful but it would be
very helpful still to have a clear discussion as to why this is all
needed. From what I can tell the functionality is already there and
another clock device (CLOCK_SGI_CYCLE) is already providing a model for
how a PTP clock could be controlled and used.


