Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0KUGF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 01:05:58 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50462 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0KUGF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 01:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UjOksbIRUupIc0ao1aAvVJXaZ3io3vCueMFaJYxmYWuteHXoxoxv/jYmjytU8C3vY4
         tfEgkj6IpLhSg8h6zZEL/TQsdy+SzQApbaoS/VvqIUBz/vQYmr+t5Zqyg9I5Y5A0ZhEt
         uGOXVEouhvvRmfZLHn4FA0noRFEgIZ6zX+3J8=
Date: Sun, 21 Nov 2010 14:09:07 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: use unsigned long inside /proc/*/statm
Message-ID: <20101121060907.GE9099@hack>
References: <20101120014114.GA31477@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120014114.GA31477@core2.telecom.by>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 03:41:15AM +0200, Alexey Dobriyan wrote:
>/proc/*/statm code needlessly truncates data from unsigned long to int.
>One needs only 8+ TB of RAM to make truncation visible.
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
