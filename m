Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0DSSih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:38:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18476 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0DSSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:38:36 -0400
Message-ID: <4BCCA315.3090009@oracle.com>
Date: Mon, 19 Apr 2010 11:38:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace-cmd: make Makefile rpm-friendly
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com> <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BCCA31F.0183:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/10 11:11, John Kacur wrote:
> 
> 
> On Mon, 19 Apr 2010, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Update Makefile to support rpmbuild DESTDIR usage.
> 
> So, what would happen if you did
> make DESTDIR=/usr/local install ?
> 
> I think you would get /usr/local/usr/local
> So, I think I would NAK this patch.
> 
> I also don't believe there is anything magical about DESTDIR in a spec 
> file. Essentially, prefix in this makefile is equivalent to DESTDIR, so 
> you can replace DESTDIR with prefix in a spec template.

I see.  Thanks for your comments.

-- 
~Randy
