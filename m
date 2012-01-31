Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2AaBYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:30 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52280 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2AaBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
	<20120130222717.GA6393@kroah.com>
Date: Mon, 30 Jan 2012 17:27:06 -0800
In-Reply-To: <20120130222717.GA6393@kroah.com> (Greg KH's message of "Mon, 30
	Jan 2012 14:27:17 -0800")
Message-ID: <m18vkoirv9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX195tOmovP+N3niQrjMxWTeYsiSWM3dmdkY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Jan 30, 2012 at 10:10:59PM +0000, Alan Cox wrote:
>> > Isn't there some other "proper" way of doing this in userspace, or is
>> > this really the correct way?
>> 
>> You can look at the S_IFMT bits and stuff however link count indicating
>> number of subdirectories is a standard Unix thing and used by many quite
>> mundane tools as an optimisation.
>
> Ah, yeah, that is easier.
>
> Eric, care to fix this or want me to revert it?

With respect to sensors the conversation has already been had, and I fix
is already queued and should come out in the sensors release due out in
a week or so.  So sensors should be fixed before this code is merged
into Linus's kernel.

Now why something minor like sensors that nothing seems to depend
strongly on should stop a system from booting is a huge question.

So I am going to have the conversation to triage what is up with
systemd.  That seems totally unexpected.

Eric
