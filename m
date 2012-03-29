Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2C2FRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:17:01 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2C2FQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:16:54 -0400
Message-ID: <4F73F042.1010400@gmail.com>
Date: Thu, 29 Mar 2012 08:16:50 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <4F71C54C.7060804@gmail.com> <CAK1hOcO7OOEJyEev+5u++piQSU6fW49wEzMagaCoX5_BzvJ=ag@mail.gmail.com>
In-Reply-To: <CAK1hOcO7OOEJyEev+5u++piQSU6fW49wEzMagaCoX5_BzvJ=ag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.27 18:33, Denys Vlasenko wrote:
> Can you also let it run longer, to test at least up to
> first 5 billion numbers (which is>  232)?

First test after ~20 hour run:
Tested 12514754560
