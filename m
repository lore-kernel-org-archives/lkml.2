Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0JEQuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:50:44 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:40798 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0JEQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:50:44 -0400
Message-ID: <4CAB5761.4030608@tilera.com>
Date: Tue, 5 Oct 2010 12:50:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: replace some BUG_ON checks with BUILD_BUG_ON checks
References: <1286294129-6205-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1286294129-6205-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/5/2010 11:55 AM, Akinobu Mita wrote:
> Some BUG_ON checks can be detected at compile time rather than
> at runtime.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>
> This patch is not compile tested.

It compiles fine.

Accepted, thanks.  I also noticed another one in arch/tile/kernel/setup.c,
so I'll fix that one too.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

