Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2AaWjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:39:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2AaWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:39:37 -0500
Message-ID: <4F286DA1.6060404@canonical.com>
Date: Tue, 31 Jan 2012 17:39:29 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120113 Thunderbird/10.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Lubos Kolouch <lubos.kolouch@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com> <20120121184453.GA2698@nbgentoo> <86hazokcb7.fsf@sumi.keithp.com> <20120122102912.GA2123@nbgentoo> <867h0j83vx.fsf@sumi.keithp.com> <20120123063313.GA2113@nbgentoo> <86vcnyc3t3.fsf@sumi.keithp.com> <20120127101403.GA2213@nbgentoo.nlcz.cz> <86liot9dod.fsf@sumi.keithp.com>
In-Reply-To: <86liot9dod.fsf@sumi.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 01:57 PM, Keith Packard wrote:
> On Fri, 27 Jan 2012 11:14:03 +0100, Lubos Kolouch<lubos.kolouch@gmail.com>  wrote:
>> On Wed, Jan 25, 2012, 23:37:28, Keith Packard wrote:
>>> On Mon, 23 Jan 2012 07:33:14 +0100, Lubos Kolouch<lubos.kolouch@gmail.com>  wrote:
>>>
>>>> dmesg after boot - http://paste.pocoo.org/show/539115/
>>>> dmesg after OK resume - http://paste.pocoo.org/show/539117/
>>>
>>> I've posted a couple of more comprehensive patches that you should have
>>> received; I'd like to know if you can test them to see if they resolve
>>> the issue as well.
>>
>> 1) applied the first patch, resume works OK
>> dmesg after boot : http://paste.pocoo.org/show/541205/
>> dmesg after resume : http://paste.pocoo.org/show/541206/
>>
>> 2) applied second patch on top, resume works OK
>> dmesg after boot: http://paste.pocoo.org/show/541477/
>> dmesg after resume : http://paste.pocoo.org/show/541479/
>
> Thanks!
>
> I'll append a 'Tested-by: Lubos Kolouch<lubos.kolouch@gmail.com>'
>
> to these patches when they go into the kernel.
>
Hi Keith,

Do you plan on submitting a request to have these patches go in to the 
3.2 stable kernel as well?

Thanks,

Joe
