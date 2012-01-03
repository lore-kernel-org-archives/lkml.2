Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2ACDq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 22:46:58 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47392 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ACDqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 22:46:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Trond.Myklebust\@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs\@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "neilb\@suse.de" <neilb@suse.de>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "devel\@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 01/11] SYSCTL: export root and set handling routines
References: <20111214103602.3991.20990.stgit@localhost6.localdomain6>
	<20111214104449.3991.61989.stgit@localhost6.localdomain6>
	<m1bor6rg39.fsf@fess.ebiederm.org> <4EEEFC54.10700@parallels.com>
	<m18vm8g951.fsf@fess.ebiederm.org> <4EEF2C9A.8000403@parallels.com>
	<m1pqfkecw0.fsf@fess.ebiederm.org> <4EEF7364.8000407@parallels.com>
Date: Mon, 02 Jan 2012 19:49:00 -0800
In-Reply-To: <4EEF7364.8000407@parallels.com> (Stanislav Kinsbursky's message
	of "Mon, 19 Dec 2011 21:24:52 +0400")
Message-ID: <m1vcotigyb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+yCFygCVLej5Hq6ae0Wbd4D/FbGfEHHik=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> 19.12.2011 20:37, Eric W. Biederman пишет:
>> Stanislav Kinsbursky<skinsbursky@parallels.com>  writes:
>>
>> Doing that independently of the rest of the sysctls is pretty horrible
>> and confusing to users.   What I am planning might suit your needs and
>> if not we need to talk some more about how to get the vfs to do
>> something reasonable.
>>
>
> Ok, Eric. Would be glad to discuss your sysctls plans.
> But actually you already know my needs: I would like to make sysctls work in the
> way like sysfs does: i.e. content of files depends on mount maker -
> not viewer.

What drives the desire to have sysctls depend on the mount maker?
Especially what drives that desire not to have it have a /proc/<pid>/sys
directory that reflects the sysctls for a given process.

Eric

