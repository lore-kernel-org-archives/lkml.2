Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2HQRBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:01:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59836 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327Ab2HQRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:01:32 -0400
Message-ID: <502E78AF.7070304@mvista.com>
Date: Fri, 17 Aug 2012 21:00:31 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Marina Makienko <makienko@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 03/13] ide: Potential null pointer dereference in ide_queue_pc_tail()
References: <1344520529-19164-1-git-send-email-makienko@ispras.ru> <20120809151342.2941f851@pyramind.ukuu.org.uk>
In-Reply-To: <20120809151342.2941f851@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09.08.2012 18:13, Alan Cox wrote:

> On Thu,  9 Aug 2012 17:55:20 +0400
> Marina Makienko <makienko@ispras.ru> wrote:

>> The function blk_get_request() can return NULL in some cases. There are
>> checks on it if function is called with argumetns one of which is
>> GFP_ATOMIC/GFP_NOIO/etc. If system couldn't find request
>> blk_get_request() return NULL.

> drivers/ide is obsolete and scheduled for removal.

    When it was scheduled for removal? I can't find an entry in 
Documentation/feature-removal-schedule.txt. And how can that be when there 
are still many unconverted drivers?

> I'm not sure messing with it is remotely useful at this point ?

    It's being maintained for bug fixes still, AFAIK.

MBR, Sergei

