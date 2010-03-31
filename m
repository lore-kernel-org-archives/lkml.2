Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0CaSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:09:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35526 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0CaSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:09:55 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] tagged sysfs support
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
	<20100331172110.GA18838@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 31 Mar 2010 11:09:46 -0700
In-Reply-To: <20100331172110.GA18838@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 31 Mar 2010 12\:21\:10 -0500")
Message-ID: <m1vdccwefp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: serue@us.ibm.com, netdev@vger.kernel.org, bcrl@lhnet.ca, eric.dumazet@gmail.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, kay.sievers@vrfy.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> The main short coming of using multiple network namespaces today
>> is that only network devices for the primary network namespaces
>> can be put in the kobject layer and sysfs.
>> 
>> This is essentially the earlier version of this patchset that was
>> reviewed before, just now on top of a version of sysfs that doesn't
>> need cleanup patches to support it.
>> 
>> I have been running these patches in some form for well over a
>> year so the basics should at least be solid.  
>> 
>> This patchset is currently against 2.6.34-rc1.
>> 
>> This patchset is just the basic infrastructure a couple of more pretty
>> trivial patches are needed to actually enable network namespaces to use this.
>> My current plan is to send those after these patches have made it through
>> review.
>
> Thanks very much for keeping this going, Eric!  I'm going to keep
> looking through the code some more, but so far I see no problems.
>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
>
> to the full patchset.  I'm really hoping you'll also include the
> patch to implement the netns support (i.e. basically commit
> fdc0adeaa8bfab9a179e1eb349cab400ddb70403 that you sent inline this
> morning to Tejun).

One step at a time.  My goal is to have it all send out and reviewed
in time for 2.6.35.

Eric
