Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2FNOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:14:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39000 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2FNOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:14:18 -0400
Message-ID: <4FD9F19E.4000209@linux.vnet.ibm.com>
Date: Thu, 14 Jun 2012 09:13:50 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] staging: zsmalloc: fix uninit'ed variable warning
References: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com> <4FD93FE8.1030102@kernel.org>
In-Reply-To: <4FD93FE8.1030102@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061414-1780-0000-0000-0000067045D9
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00147990; UDB=6.00033754; UTC=2012-06-14
 14:14:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 08:35 PM, Minchan Kim wrote:

> Nice catch!


by Andrew!

> Nitpick:
> I can't see the warning.
> My gcc version is gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3.


I couldn't either but Andrew could and he verified the fix.

Not sure what gcc version he is running.

> Please, Cced linux-mm, too.
> Some guys in mm might have a interest in zsmalloc. :)


Meant to include linux-mm :-/  I'll be sure to include
them in future zsmalloc patches.

