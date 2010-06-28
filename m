Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0F1Mgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:36:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35923 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0F1Mgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:36:49 -0400
Message-ID: <4C28975F.70902@cs.helsinki.fi>
Date: Mon, 28 Jun 2010 15:36:47 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Lars Lindley <lindley@coyote.org>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] trivial: use ARRAY_SIZE
References: <1277726138-24865-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277726138-24865-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/10 2:55 PM, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
>
> Signed-off-by: Kulikov Vasiliy<segooon@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
