Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab2GVFs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 01:48:56 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:58109 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777Ab2GVFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 01:48:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1207211905010.1570@eggly.anvils>
References: <50079125.3020007@wpkg.org> <CAL1RGDU8TVBkZ4yP=kjwqvGUsrnQcBGpLa_x-7c=Gu54piVwyw@mail.gmail.com>
 <alpine.LSU.2.00.1207211905010.1570@eggly.anvils>
From: Roland Dreier <roland@purestorage.com>
Date: Sat, 21 Jul 2012 22:48:32 -0700
Message-ID: <CAL1RGDXUfcZi9gsinrmEDrWXAjtmRFJkkwHQyx=8=A=TDL9cBw@mail.gmail.com>
Subject: Re: 3.5-rc7 - can no longer wake up from suspend to RAM
To: Hugh Dickins <hughd@google.com>
Cc: Tomasz Chmielewski <tch@wpkg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Hugh.  I just went ahead and built 3.5 final, and suspend/resume
look to be working again.

I'm not even going to try to understand how a timekeeping bug broke resume...

 - R.
