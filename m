Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1EKDE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 23:04:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43804 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1EKDEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 23:04:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Please include the namespace file-descriptors tree in linux-next
References: <m1sjsmp44c.fsf@fess.ebiederm.org>
	<20110511102736.7a9dc881.sfr@canb.auug.org.au>
Date: Tue, 10 May 2011 20:04:17 -0700
In-Reply-To: <20110511102736.7a9dc881.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Wed, 11 May 2011 10:27:36 +1000")
Message-ID: <m1sjsmdjke.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/4LzgqUqhlsgCZDS8zsnel+2dZNE5yFqI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> On Tue, 10 May 2011 15:44:51 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
>>
>> These changes have just been through review and I expect
>> to send Linus a pull request when the merge window opens.
>> 
>> This tree holds changes that significantly simply the userspace
>> interface to working with namespaces.
>> 
>> I had to pull some of net-next and the parisc tress to be able to
>> avoid conflicts with system call numbers.  Hopefully that is not
>> a problem.
>
> That should be fine as Dave's tree never rebases and the parisc tree
> looks pretty stable.  Just keep an eye on those trees, just in case.

Good point.  I have talked to James and Dave so they know I pulled their
trees.  My lazy side says I expect you will get a merge conflict with my
tree in linux-next if someone rebases.  But I will definitely keep my
eyes out and at the very least double check that all is well before I
send Linus a pull request.  

Eric
