Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2AQQv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:51:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53056 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2AQQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:51:57 -0500
Message-ID: <4F15A729.4000600@garzik.org>
Date: Tue, 17 Jan 2012 11:51:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Lin Ming <ming.m.lin@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.3
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com> <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr> <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com> <CA+55aFy+1DWUaOMormPHy7hCJxNfdxmiAnj8W0gqNTbeogNN4w@mail.gmail.com> <CA+55aFxvUvWHbJvconcjPmDhUVcCRGxxA-iD+HEngRSt4iox5g@mail.gmail.com> <1326777393.13517.39.camel@minggr> <CA+55aFzNpK0z2A8-0v2bLEX_Wma5f3tkeSVjAdwpkrW0=3V_Wg@mail.gmail.com>
In-Reply-To: <CA+55aFzNpK0z2A8-0v2bLEX_Wma5f3tkeSVjAdwpkrW0=3V_Wg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 12:19 AM, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 9:16 PM, Lin Ming<ming.m.lin@intel.com>  wrote:
>>
>> But ata port async suspend was not enabled in above patch.
>> So I think this is a regression.
>
> Ok. Jeff? Should I take that patch directly, or will you take it?

Coming today, with at least one other change...  still keeping an eye 
out for possible PM problems on older non-AHCI SATA hardware.

	Jeff




