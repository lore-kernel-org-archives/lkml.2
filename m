Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0HDSDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:03:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61285 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0HDSDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:03:05 -0400
To: Mark Lord <kernel@teksavvy.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't used!
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4C58C528.4000606@tuxonice.net> <4C5960B0.7020003@teksavvy.com>
Date: Wed, 04 Aug 2010 14:02:10 -0400
In-Reply-To: <4C5960B0.7020003@teksavvy.com> (Mark Lord's message of "Wed, 04
	Aug 2010 08:44:32 -0400")
Message-ID: <yq17hk6qmsd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C59AB2F.0055:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> Looks to me like more and more things are using the block discard
Mark> functionality, and as predicted it is slowing things down
Mark> enormously.

Mark> The problem is that we still only discard tiny bits (a single
Mark> range still??)  per TRIM command, rather than batching larger
Mark> ranges and larger numbers of ranges into single TRIM commands.

Mark> That's a very poor implementation, especially when things start
Mark> enabling it by default.  Eg. the swap code, mke2fs, etc..

I'm working on aggregation.  But it's harder than we initially
thought...

-- 
Martin K. Petersen	Oracle Linux Engineering
