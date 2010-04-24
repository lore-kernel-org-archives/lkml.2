Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0DXCQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:16:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36856 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0DXCQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004231204450.1777-100000@iolanthe.rowland.org>
References: <1271984938-13920-2-git-send-email-arve@android.com>
	 <Pine.LNX.4.44L0.1004231204450.1777-100000@iolanthe.rowland.org>
Date: Fri, 23 Apr 2010 19:15:59 -0700
Message-ID: <p2vd6200be21004231915o5b2d4ed1zbabd3e51e6213f45@mail.gmail.com>
Subject: Re: [PATCH 1/9] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/23 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 22 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:
...
>> +Calling suspend_block when the suspend blocker is active or suspend_unblock when
>> +it is not active has no effect. This allows drivers to update their state and
>> +call suspend suspend_block or suspend_unblock based on the result.
>
> But suspend_block() and suspend_unblock() don't nest.  You should
> mention this.
>

I'm not sure what you mean by this? I think the first sentence
dictates nesting is not supported.

I think the rest of your comments will be addressed in the next
version of the document, that I worked with Rafael on.

-- 
Arve Hjønnevåg
