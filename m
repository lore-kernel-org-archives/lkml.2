Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1A1OWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:22:23 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:20349 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752418Ab1A1OWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:22:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABNgQk1Ld/sX/2dsb2JhbAAMhAjNB5B0gSODOHQEhRg
X-IronPort-AV: E=Sophos;i="4.60,392,1291611600"; 
   d="scan'208";a="89555764"
Message-ID: <4D42D11A.5040201@teksavvy.com>
Date: Fri, 28 Jan 2011 09:22:18 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Dave Chinner <david@fromorbit.com>, Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard> <4D421A68.9000607@teksavvy.com> <AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
In-Reply-To: <AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 11:14 PM, David Rees wrote:
>
> As suggested before - why are you messing with AGs instead of allocsize?

Who said "instead of"?  I'm using both.

Cheers
