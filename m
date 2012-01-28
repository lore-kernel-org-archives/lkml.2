Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2A1Utc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 15:49:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52886 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2A1Utb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 15:49:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] fix devpts mount behavior
References: <20120124000517.GA28878@sergelap>
	<CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
	<20120124002555.GA29534@sergelap>
	<CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
	<20120124010758.GJ23916@ZenIV.linux.org.uk>
	<m1k44gj1cu.fsf@fess.ebiederm.org> <20120124220247.GA26353@hallyn.com>
	<CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
	<20120124231601.GA4470@sergelap>
	<CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
	<20120128195103.GA11299@sergelap>
Date: Sat, 28 Jan 2012 12:52:00 -0800
In-Reply-To: <20120128195103.GA11299@sergelap> (Serge Hallyn's message of
	"Sat, 28 Jan 2012 13:51:03 -0600")
Message-ID: <m139azpn2n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19tNgy1rPe4wqpWo8Hn8Vt9Ikt+vgiZZnY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@canonical.com> writes:

> Quoting Kay Sievers (kay.sievers@vrfy.org):
>> We might also thing about changing /sys/class/tty/ptmx/, and have the
>> kernel create the symlink? The loops through userspace to setup
>> default kernel stuff are kind of crazy ...
>> 
>> Kay
>
> Hi Kay,
>
> sorry, there is something I'm missing here.  Without a target kobj
> to link to, how would we go about telling the kernel that /dev/ptmx
> should be a symlink to /dev/pts/ptmx?  Is there a way to do that?

There is precedent in the /dev/fd symlinks, so I expect you want
to look and see where the configuration for that comes from.

Eric
