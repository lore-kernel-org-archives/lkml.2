Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2DXCNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:13:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53815 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2DXCNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:13:49 -0400
Date: Tue, 24 Apr 2012 11:43:40 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Adds Kconfig option for Cross Memory Attach
Message-ID: <20120424114340.79825228@Gantu>
In-Reply-To: <4F9579E4.2000701@xenotime.net>
References: <20120423134243.5ac73596@Gantu>
	<4F9579E4.2000701@xenotime.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12042316-1618-0000-0000-00000161EA84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 08:48:52 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 04/22/2012 09:12 PM, Christopher Yeoh wrote:
> 
> > Hi Andrew,
> > 
> > Attached is a patch which you asked for a while back which adds a
> > Kconfig option to allow people who don't want cross memory attach
> > to not have it included in their build.
> 
> 
> and it shouldn't be default y.
> 
> Linus has written a diatribe on [not] making new options
> default to y.

I'm not that fussed, but currently CMA is enabled whether you like it
or not. This just allows you to disable it. IIRC there was an exception
where a new config option allows you to disable an old feature
(although CMA has not been out that long).

Regards,

Chris
-- 
cyeoh@au.ibm.com

