Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0LWRMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:12:35 -0500
Received: from jcz.nl ([213.196.18.5]:53640 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0LWRMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:12:33 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 12:12:33 EST
Message-ID: <4D138147.3010004@jcz.nl>
Date: Thu, 23 Dec 2010 18:05:11 +0100
From: Jaap Crezee <jaap@jcz.nl>
Organization: JCZ-Automatisering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "jmoyer@redhat.com >> Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>	<20101220190630.66084e1d@neptune.home>	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>	<20101222104306.GB30941@bitwizard.nl>	<x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>	<20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/10 15:40, Jeff Moyer wrote:
> Your logic is a bit flawed, for so many reasons I'm not even going to
> try to enumerate them here.  Anyway, I'll continue to sound like a
> broken record and ask for blktrace data.
> Anyway, it will be much easier to debate the issue once the blktrace
> data is gathered.

Here you are:

http://jcz.nl:8080/blktrace.log

Regards,

Jaap Crezee


PS Today one drive failed with IO errors and is currently "dead". The performance increased a little...
