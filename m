Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab0JGPKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:10:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0JGPKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:10:46 -0400
Message-ID: <4CADE2F3.8000908@zytor.com>
Date: Thu, 07 Oct 2010 08:10:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain	 erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com> <4CADCF23.5070800@zytor.com> <4CADEED9020000780001B44F@vpn.id2.novell.com> <4CADD442.4050706@zytor.com> <4CADFAE6020000780001B4DC@vpn.id2.novell.com>
In-Reply-To: <4CADFAE6020000780001B4DC@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 07:52 AM, Jan Beulich wrote:
>>>> On 07.10.10 at 16:08, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> On 10/07/2010 07:01 AM, Jan Beulich wrote:
>>>>
>>>> Those Atoms don't have 64-bit support.
>>>
>>> That's different from what I found looking around on the web.
>>>
>>
>> Do tell...
> 
> E.g.
> 
> http://en.wikipedia.org/wiki/List_of_Intel_Atom_microprocessors
> 
> in particular the Atom 230 and Atom 330 (which to my reading match
> the spec updates for the 200 and 300 series, which in turn exhibit
> the erratum in question).
> 

You're right... I misremembered.  The question is what to do at this
point, since we're already in trouble.  A possible failure on startup
seems better than a state in which we could get data corruption at
almost any time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

