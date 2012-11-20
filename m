Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2KTEzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:55:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2KTEzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:55:23 -0500
Message-ID: <50AB0D27.6090205@zytor.com>
Date: Mon, 19 Nov 2012 20:55:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Russ Anderson <rja@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jack Steiner <steiner@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        rja@americas.sgi.com
Subject: Re: [patch] x86, UV: integer wrap bug in uv_hub_ipi_value()
References: <20121117151611.GB16900@elgon.mountain> <20121120004834.GE5060@sgi.com> <20121120042855.GE6186@mwanda>
In-Reply-To: <20121120042855.GE6186@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 08:28 PM, Dan Carpenter wrote:
>
> I do feel a little embarrassed that I didn't use "unsigned long"
> consistently.  I just used ulong to make the line a bit shorter, but
> I could redo it with "unsigned long" if you want.
>

Yes, "ulong" is not idiomatic in the Linux kernel.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

