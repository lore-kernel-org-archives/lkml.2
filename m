Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1BVOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:38:49 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:56231 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab1BVOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:38:46 -0500
Date: Tue, 22 Feb 2011 15:38:44 +0100
From: Alexander Wuerstlein <arw@arw.name>
To: hayeswang <hayeswang@realtek.com>
Cc: "'David S. Miller'" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "'franois romieu'" <romieu@fr.zoreil.com>
Subject: Re: r8169 hangs machine on kernel boot (bisected)
Message-ID: <20110222143844.GG18860@cip.informatik.uni-erlangen.de>
References: <20110216223438.GZ15516@cip.informatik.uni-erlangen.de>
 <CDC3F2AD9A574AC4B7DDDB7D64329A79@realtek.com.tw>
 <20110218173013.GC15516@cip.informatik.uni-erlangen.de>
 <74B28238B88A415E96A0B885B5B6A8A6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74B28238B88A415E96A0B885B5B6A8A6@realtek.com.tw>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4 cocaine
 saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-02-22 13:31, hayeswang <hayeswang@realtek.com> wrote:
> Hello,
> 
> please use the patch of the attatched file to check if it fix the issue. Thanks.

Yes, the patch you sent applied to a kernel from git (rev ee715087024b)
fixes the issue. I'll also test applying on -rc6 later and report.

Thanks alot for your help!


Ciao,

Alexander Wuerstlein.
