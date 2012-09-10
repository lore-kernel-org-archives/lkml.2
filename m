Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2IJKSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:18:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:60945 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2IJKSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:18:10 -0400
Message-ID: <504DBE81.7030004@parallels.com>
Date: Mon, 10 Sep 2012 14:18:41 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: <miklos@szeredi.hu>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/6] fuse: allocate req->pages[] dynamically
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
In-Reply-To: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that 'Signed-off-by' is missed in my patches. Very sorry for 
inconvenience. I'll be more careful next time.

Thanks,
Maxim

09/07/2012 09:40 PM, Maxim Patlasov пишет:
> Hi,
>
> Currently, any fuse request always includes inline pages[] array of
> FUSE_MAX_PAGES_PER_REQ elements. This is the waste of memory because
> in many cases smaller size would suffice.
> ...
