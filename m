Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0GTFGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 01:06:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41152 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab0GTFGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 01:06:03 -0400
Date: Mon, 19 Jul 2010 22:05:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Kees Bakker <kees.bakker@xs4all.nl>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] documentation: fix almost duplicate filenames 
 (io/IO-mapping.txt)
Message-Id: <20100719220545.098cb7aa.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
	<AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0201.4C452EAE.0108:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 19:27:13 -0700 Linus Torvalds wrote:

> On Mon, Jul 19, 2010 at 6:12 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > (hopefully I got this right.  I'm not a big git user.)
> 
> Hmm. No.
> 
> The commit otherwise looks correct, but the commit message is
> buggered. The first line of the message is
> 
>    From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> rather than the subject of the patch itself.
> 
> No fear. Practice makes perfect. Just try again ;)


Will do... but how do I edit the commit message?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
