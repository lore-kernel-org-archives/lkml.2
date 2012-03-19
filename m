Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2CSSC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:02:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39982 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2CSSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:02:27 -0400
Message-ID: <4F67749E.50208@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 14:02:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: dledford@redhat.com
CC: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        amwang@redhat.com, jslaby@suse.cz, ebiederm@xmission.com,
        joe.korty@ccur.com, dhowells@redhat.com
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com> <4EEE3124.7070605@gmail.com> <20111218103836.258eedb8.akpm@linux-foundation.org> <4F610D81.3020300@redhat.com> <20120314143832.286b497e.akpm@linux-foundation.org> <4F611169.2020205@redhat.com>
In-Reply-To: <4F611169.2020205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2012 5:45 PM, Doug Ledford wrote:
> On 03/14/2012 05:38 PM, Andrew Morton wrote:
>> On Wed, 14 Mar 2012 17:28:33 -0400
>> Doug Ledford <dledford@redhat.com> wrote:
>>
>>> This has obviously fallen through the cracks.
>>
>> It sure has.  Please dig out whatever is the currently favored
>> patchset, refresh, retest and resend, with changelogging which fully
>> covers the reasoning and decision process?
> 
> OK, completely redoing patch set then against current Linus tree.
> 
> Motohiro, would you be so kind as to resend my your patches that went on
> top of mine and I'll create a complete patch set?

I'm sorry. I already have a rebased patch. but I haven't posted. I have to
hurry.


> 
>>> so that if there are any apps out there that have been coded to expect
>>> this behavior, then there is a workaround path for them until they get
>>> coded
>>
>> We'll be especially interested in the implications of this part.
> 
> Certainly.
> 

