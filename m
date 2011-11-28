Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1K1UFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:05:18 -0500
Received: from blu0-omc1-s1.blu0.hotmail.com ([65.55.116.12]:62946 "EHLO
	blu0-omc1-s1.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836Ab1K1UFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:05:16 -0500
X-Originating-IP: [87.194.136.79]
X-Originating-Email: [piercing_male@hotmail.com]
Message-ID: <BLU0-SMTP36987CC5BAE13BD585AA31198B20@phx.gbl>
Subject: Re: linear raid, is partial recovery possible?
From: wilsonjonathan <piercing_male@hotmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1322506426.2259.33.camel@AOC>
References: <1322506426.2259.33.camel@AOC>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 20:05:15 +0000
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2011 20:05:14.0233 (UTC) FILETIME=[0A944690:01CCAE09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore as sent to wrong list.

On Mon, 2011-11-28 at 18:53 +0000, wilsonjonathan wrote:
> Quick question regarding linear raid.
> 
> If a disk fails on a linear raid I understand how the raid is
> non-recoverable, as a whole, as it has lost a chunk of data.
> 
> However is it possible to recover the data from the non-failed portion
> of the raid as I assume linear works by starting at one end of the array
> and slowly progresses to the other?
> 
> Or perhaps it is dependent on the file system on the array, eg. ext
> works by trying to place files distant to each other to help reduce the
> possibility of fragmentation?
> 
> Perhaps the filesystem meta data, or some portion, may span between two
> physical drives which would corrupt its table?
> 
> And obviously if a file spans two disks it would be missing part of its
> data?
> 
> Does the raid underlying a file system do its own things, re-space,
> physical data layout, etc; or does/can a file system impact on the
> workings of an array?
> 
> The more I look into software raid the more fasinated I become with it
> and its inner workings. While its way beyond me in some of the maths and
> the fact I am un-proficient in C it has really caught my intrigue, and
> all because I wanted to set up a small home server ;-)
> 


