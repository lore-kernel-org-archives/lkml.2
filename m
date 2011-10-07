Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1JGQBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:01:20 -0400
Received: from tango.0pointer.de ([85.214.72.216]:36072 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1JGQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:01:20 -0400
Date: Fri, 7 Oct 2011 18:01:14 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Biederman Eric Biederman <ebiederm@xmission.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007160113.GB14201@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <20111007074904.GC16723@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007074904.GC16723@count0.beaverton.ibm.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07.10.11 00:49, Matt Helsley (matthltc@us.ibm.com) wrote:

> 
> On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:
> 
> <snip>
> 
> > * simple, reliable and future-proof way to detect whether a specific pid
> > is running in a CLONE_NEWPID container, i.e. not in the root PID
> > namespace. Currently, there are available a few ugly hacks to detect
> 
> Is that precisely what's needed or would it be sufficient to know
> that the pid is running in a child pid namespace of the current pid
> namespace? If so, I think this could eventually be done by comparing
> the inode numbers assigned to /proc/<pid>/ns/pid to those of
> /proc/1/ns/pid.

I think the most interesting test would be to figure out for a process
if itself is running in a PID namespace. And for that comparing inodes
wouldn't work since the namespace process would never get access to the
inode of the outside init.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
