Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380Ab2EQJHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:07:08 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42569 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759433Ab2EQJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:07:00 -0400
Subject: Re: NVM Mapping API
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120516161020.GJ22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
	 <1337149453.1961.24.camel@slavad-ubuntu-11>
	 <20120516161020.GJ22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 May 2012 13:06:44 +0400
Message-ID: <1337245604.2521.166.camel@slavad-ubuntu-11>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.176.166.14 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> No, I can't comment on any of that.  This isn't about any particular piece
> of technology; it's an observation that there are a lot of technologies
> that seem to fit in this niche; some of them are even available to
> buy today.
> 
> No statement of mine should be taken as an indication of any future
> Intel product plans :-)
> 

Ok. I understand. :-)

> > There are a number of interesting non-volatile memory (NVM) technologies
> > > being developed.  Some of them promise DRAM-comparable latencies and
> > > bandwidths.  At Intel, we've been thinking about various ways to present
> > > those to software.
> > 

We can be more and more radical in the case of new NVM technologies, I
think. The non-volatile random access memory with DRAM-comparable read
and write operations' latencies can change computer world dramatically.
Just imagine a computer system with only NVM memory subsystem (for
example, it can be very promising mobile solution). It means that we
can forget about specified RAM and persistent storage solutions. We can
keep run-time and persistent information in one place and operate it on
the fly. Moreover, it means that we can keep any internal OS's state
persistently without any special efforts. I think that it can open new
very interesting opportunities.

The initial purpose of a filesystem is to distinguish run-time and
persistent information. Usually, we have slow persistent memory
subsystem (HDD) and fast run-time memory subsystem (DRAM). Filesystem
is a technique of synchronization a slow persistent memory subsystem
with fast run-time memory subsystem. But if we will have a fast memory
that can keep run-time and persistent information then it means a
revolutionary new approach in memory architecture. It means that two
different entities (run-time and persistent) can be one union. But for
such joined information entity traditional filesystems' and OS's
internal techniques are not adequate approaches. We need in
revolutionary new approaches. From NVM technology point of view, we can
be without filesystem completely, but, from usual user point of view,
modern computer system can't be imagined without filesystem.

We need in filesystem as a catalogue of our persistent information. But
OS can be represented as catalogue of run-time information. Then, with
NVM technologies, the OS and filesystem can be a union entity that
keeps as persistent as run-time information in one catalogue structure.
But such representation needs in dramatically reworking of OS internal
techniques. It means that traditional hierarchy of folders and files is
obsolete. We need in a new information structure approaches.
Theoretically, it is possible to reinterpret all information as
run-time and to use OS's technique of internal objects structure. But
it is impossible situation from end users point of view. So, we need in
filesystem layer anyway as layer which represent user information and
structure of it.

If we can operate and keep internal OS representation of information
then it means that we can reject file abstraction. We can operate by
information itself and keep information without using different files'
formats. But it is known that all in Linux is a file. Then, factually,
we can talk about completely new OS.

Actually, NVM technologies can support possibility doesn't boot OS
completely. Why does it need to boot if it is possible to keep any OS
state in memory persistently? I think that OS booting can be obsolete
thing.

Moreover, it is possible to be without swapping completely because all
our memory can be persistent. And for system with NVM memory only request
queue and I/O scheduler can be obsolete thing. I think that kernel
memory page approach can be redesign significantly, also. Such thing as
shared libraries can be useless because all code pieces can be
completely in memory.

So, I think that all what I said can sound as a clear fantasy. But,
maybe, it needs to discuss about new OS instead of new filesystem. :-) 

With the best regards,
Vyacheslav Dubeyko.



