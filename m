Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab2GVFwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 01:52:05 -0400
Received: from mail.virtall.com ([178.63.195.102]:37522 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab2GVFwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 01:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=default; b=3dx
	v1tiShpLdnapZVqi2o+X5itBqsZmMVFSvEZuZr0wLEpMfhdHhqAj4rt9Kunvkayj
	5+iEuOBbznutOIE6Q4FBuBkZz5EaVWEyo9bIIQ/Hn+HWcn+VCiDWx0xTA/sgbWoZ
	MIOKp2Y88WATgYVmPD2rC7QJjyKwu5pPAst4TH4M=
Message-ID: <500B94F9.9070200@wpkg.org>
Date: Sun, 22 Jul 2012 12:51:53 +0700
From: Tomasz Chmielewski <tch@wpkg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.5-rc7 - can no longer wake up from suspend to RAM
References: <50079125.3020007@wpkg.org> <CAL1RGDU8TVBkZ4yP=kjwqvGUsrnQcBGpLa_x-7c=Gu54piVwyw@mail.gmail.com> <alpine.LSU.2.00.1207211905010.1570@eggly.anvils> <CAL1RGDXUfcZi9gsinrmEDrWXAjtmRFJkkwHQyx=8=A=TDL9cBw@mail.gmail.com>
In-Reply-To: <CAL1RGDXUfcZi9gsinrmEDrWXAjtmRFJkkwHQyx=8=A=TDL9cBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 12:48 PM, Roland Dreier wrote:
> Thanks Hugh.  I just went ahead and built 3.5 final, and suspend/resume
> look to be working again.
>
> I'm not even going to try to understand how a timekeeping bug broke resume...

Yep, seems to be working fine here, too.

-- 
Tomasz Chmielewski
http://www.ptraveler.com

