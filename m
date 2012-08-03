Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2HCOLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:11:12 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:8815 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2HCOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:11:10 -0400
X-Authority-Analysis: v=2.0 cv=Dp/UCRD+ c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=sgO5gNtQRqEA:10 a=wkBGhNO-IO0A:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=2D1OvHveRNJ-jve2AggA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <501BDBEE.60305@cfl.rr.com>
Date: Fri, 03 Aug 2012 10:10:54 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chris Friesen <chris.friesen@genband.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE("GPL")??
References: <50199E91.5040308@cfl.rr.com> <20120801224342.5b90747f@pyramind.ukuu.org.uk> <501A704E.2000301@cfl.rr.com> <501B5D51.5030307@genband.com> <501BBE45.8060309@cfl.rr.com> <20120803142923.311c70b6@pyramind.ukuu.org.uk>
In-Reply-To: <20120803142923.311c70b6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 09:29 AM, Alan Cox wrote:
>> assumption that that actually meant they were NOT using GPL symbols.
>
> All symbols in the Linux kernel are to GPL code and all linking dynamic
> or otherwise is subject to the GPL licence. That is you need to be able
> to show anything non-free linked with it such as a kernel module is not a
> derivative work.

Why then is there EXPORT_SYMBOL_GPL and EXPORT_SYMBOL? As long as you have 
them both, one can and will, assume that what you say above is not the intent.

Again, our Linux kernel drivers are and always were GPL and at least partly 
so because of EXPORT_SYMBOL_GPL.

Mark




