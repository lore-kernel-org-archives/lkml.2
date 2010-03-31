Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0CaGrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:47:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:47436 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab0CaGrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:47:31 -0400
Date: Wed, 31 Mar 2010 17:47:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
In-Reply-To: <4BB2EB1B.8090303@zytor.com>
Message-ID: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, H. Peter Anvin wrote:

> On 03/30/2010 09:49 PM, James Morris wrote:
> > Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
> > that it leads to all kinds of strange, undebuggable boot hangs and errors 
> > (with relatively current Fedora development userland).
> 
> Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?

Yes, it was happening with -rc3.

-- 
James Morris
<jmorris@namei.org>
