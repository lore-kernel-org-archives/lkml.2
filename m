Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1COKSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:18:51 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:57190 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab1COKSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:18:48 -0400
Message-ID: <4D7F3CD5.9030105@secunet.com>
Date: Tue, 15 Mar 2011 11:17:57 +0100
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: =?ISO-8859-1?Q?Andreas_Bie=DFmann?= <biessmann@corscience.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in, __mark_inode_dirty
References: <fa.8ND6HoGS9dKYUuniFCAoNq+1TFY@ifi.uio.no> <4D78AA72.3060202@secunet.com>
In-Reply-To: <4D78AA72.3060202@secunet.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2011 10:18:46.0574 (UTC) FILETIME=[5E861CE0:01CBE2FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.2011 11:39, Torsten Hilbrich wrote:
> I ran into the same problem and successfully applied your fix.
> 
> I was able to reproduce this panic and bisected it to the following commit:
> 
> commit aaead25b954879e1a708ff2f3602f494c18d20b5
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Oct 4 14:25:33 2010 +0200
> 
>     writeback: always use sb->s_bdi for writeback purposes
> 
> The steps to reproduce it on my test system (T60p with Intel Core Duo) were.

Added Christoph to CC. I also open a bug report at
https://bugzilla.kernel.org/show_bug.cgi?id=31112

	Torsten
