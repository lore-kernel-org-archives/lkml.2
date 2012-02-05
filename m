Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2BELbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:31:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60132 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2BELbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:31:22 -0500
MIME-Version: 1.0
In-Reply-To: <4F2E608B.9000904@linux.vnet.ibm.com>
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com>
	<4F29C3E3.1040108@linux.vnet.ibm.com>
	<4F2D3C90.3000708@linux.vnet.ibm.com>
	<201202042327.10045.rjw@sisk.pl>
	<CAJd=RBDz6bm-2p28506+0CuC3P6kED8kXLrZe_TPuhTQSUo67w@mail.gmail.com>
	<4F2E608B.9000904@linux.vnet.ibm.com>
Date: Sun, 5 Feb 2012 19:31:21 +0800
Message-ID: <CAJd=RBCDao9L0knyF74nN0RsGB7xKoUG_jG6o_GifesMchhbKw@mail.gmail.com>
Subject: Re: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing
 of kernel threads fails
From: Hillf Danton <dhillf@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, pavel@ucw.cz,
        len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 6:57 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 02/05/2012 11:36 AM, Hillf Danton wrote:
>
>> On Sun, Feb 5, 2012 at 6:27 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Saturday, February 04, 2012, Srivatsa S. Bhat wrote:
>>>> On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:
>>>> Hi Rafael,
>>>>
>>>> I have reworked the changelog of this patch to indicate that this fixes a
>>>> regression. Here is the updated patch:
>>>
>>> Well, I've already fixed that up in my tree, but thanks anyway. :-)
>>>
>>
>> Nicer if gurus open wider windows for patches received, no?
>>
>
>
> I am not quite sure what you meant by that, but just in case you got the
> wrong idea by any chance, let me clarify:
>
> Working with Rafael has *always* been an immensely pleasurable experience!
> There is absolutely no doubt in that :-)
>
> So there really is no reason to feel bad about the above incident :-)
>

Yes, no reason not to keep mind open.

Good weekend
Hillf
