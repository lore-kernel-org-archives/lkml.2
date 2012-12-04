Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2LDNzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:55:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2LDNzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:55:40 -0500
MIME-Version: 1.0
In-Reply-To: <50BDE224.8000301@ti.com>
References: <1354620448-14317-1-git-send-email-dinggnu@gmail.com> <50BDE224.8000301@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Dec 2012 13:55:18 +0000
X-Google-Sender-Auth: 2ldPvK48uJM5o_AFvx7vYzq0LYk
Message-ID: <CACxGe6viwuyfYm2RBfcj233U6-xmJJTQgu=DUu_11iPAckUzqg@mail.gmail.com>
Subject: Re: [PATCH] memory: of_memory.c: remove unnecessary initialization
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Cong Ding <dinggnu@gmail.com>, Benoit Cousson <b-cousson@ti.com>,
        Aneesh V <aneesh@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 11:44 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Tuesday 04 December 2012 04:56 PM, Cong Ding wrote:
>>
>> the initialization of variable ret is unnecessary, we can remove it while
>> save
>> one time "or" operation.
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> ---
>
> Looks ok.
> Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
>

Thanks for the patch, but I don't think it matters enough to apply it.
The existing code isn't wrong.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
