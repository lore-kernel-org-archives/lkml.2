Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0KIEW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:22:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40240 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0KIEWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=liaYONAUf1SVjPN007IeN9Dj50oE+kTfBuVdD5K9PB4LzIcDydxX4mzIMXdzc5ZLLq
         /A4yU9j1qvHawrwcPzNYfH9C4izKiTVfSWd/tIzsJbZvvbCqZnPCm3F/ofhJYebr4mFc
         +SAgddI6hb58CfXTBPeNMo+Srv6WVXOptHj+0=
Date: Tue, 9 Nov 2010 12:27:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Mike Waychison <mikew@google.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Message-ID: <20101109042732.GC5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109033024.GA5220@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:30:24AM +0800, Américo Wang wrote:
>
....
>
>So, either we need to de-modulize configfs or replace configfs API
>with sysfs API. Personally, I prefer the former one, I don't think
>configfs should be a module as long as it can provide API's
>for other subsystems, like debugfs.
>

To clarify, I meant "as long as the API it provides can be used by
other core subsystems".
