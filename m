Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427Ab2AFUIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:08:47 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:45317 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab2AFUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:08:45 -0500
Message-ID: <4F0754BA.8070708@linux.vnet.ibm.com>
Date: Fri, 06 Jan 2012 18:08:26 -0200
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Breno Leitao <brenohl@br.ibm.com>, Zac Storer <zac.3.14159@gmail.com>,
        leitao@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 29/29] Drivers: tty: serial: jsm: jsm_tty: fixed a brace
 coding style issue
References: <1321596182-11031-1-git-send-email-zac.3.14159@gmail.com> <4EC66C07.9020009@br.ibm.com> <4F073CF3.70604@linux.vnet.ibm.com> <4F074F89.6060300@linux.vnet.ibm.com> <20120106195332.GA10814@kroah.com>
In-Reply-To: <20120106195332.GA10814@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12010620-8936-0000-0000-0000058F1FA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 05:53 PM, Greg KH wrote:
> On Fri, Jan 06, 2012 at 05:46:17PM -0200, Lucas Kannebley Tavares wrote:
>> On 01/06/2012 04:26 PM, Lucas Kannebley Tavares wrote:
>>> On 11/18/2011 12:30 PM, Breno Leitao wrote:
>>>> On 11/18/2011 03:03 AM, Zac Storer wrote:
>>>>> Fixed a brace coding style issue.
>>>>>
>>>>> Signed-off-by: Zac Storer<zac.3.14159@gmail.com>
>>>> Acked-by: Breno Leitao<brenohl@br.ibm.com>
>>> Acked-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
>>>
>>
>> Adding Alan and Greg so they can catch this up on their trees.
>
> Catch what up with what?
>
> What patch is this?  Where is it?  Why wasn't it sent to me in the first
> place?
>
> Also note, the merge window for new patches to be sent to subsystem
> maintainers has been over for a week or so now, all of of the
> maintainers are now busy merging stuff with Linus, so trivial stuff like
> this is going to have to wait a few weeks at the earliest before it can
> start to be queued up.
>
> thanks,
>
> greg k-h
>

I said catch up because I didn't see it on any trees I looked and 
figured it had been passed over.
As for not sending it to you earlier, I and Breno had only replied to 
Zac's original CC list, and I only noticed you were missing now. But, as 
you've said it, it's a trivial patch, without great consequences 
(although good to have). No rush in it.

Thanks

Lucas

