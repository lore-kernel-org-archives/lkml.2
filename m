Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1BUUDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:03:08 -0500
Received: from xenotime.net ([184.105.210.51]:58401 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751250Ab1BUUDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:03:06 -0500
Date: Mon, 21 Feb 2011 12:03:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rob Landley <rlandley@parallels.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, LKML <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: Update to http://kernel.org/doc
Message-Id: <20110221120303.48106f6c.rdunlap@xenotime.net>
In-Reply-To: <4D62C43F.5040302@parallels.com>
References: <4D6095E3.2040103@parallels.com>
	<20110221185205.GA23284@mako-laptop>
	<4D62C43F.5040302@parallels.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 13:59:59 -0600 Rob Landley wrote:

> On 02/21/2011 12:52 PM, Mariusz Kozlowski wrote:
> >> I'm not saying it's complete.  I'm just saying I exhumed it, gave it a
> >> good scrub, applied the interocitor to the bolts on its' neck, and sent
> >> it lurching towards the village...
> >>
> >> Opinions?
> > 
> > Very useful if updated. I can now remove some portion of my kernel related
> > bookmarks.
> 
> Thanks.  I can set up a cron job, but in reality it looks prettier than
> it actually is.
> 
> Part of the problem is that "make htmldocs" doesn't reliably build
> between about -rc1 and -rc4 or so.  It's usually not part of anybody's
> regression testing, and when it DOES fail the output is usually crazy
> stuff like:
> 
> xmlto: /home/landley/linux/linux/Documentation/DocBook/80211.xml does
> not validate (status 3)
> xmlto: Fix document syntax or use --skip-validation option
> /home/landley/linux/linux/Documentation/DocBook/80211.xml:13074: element
> chapter: validity error : Element chapter content does not follow the
> DTD, expecting (chapterinfo? , (title , subtitle? , titleabbrev?) , (toc
> | lot | index | glossary | bibliography)* , tocchap? , (((calloutlist |
> glosslist | itemizedlist | orderedlist | segmentedlist | simplelist |
> variablelist | caution | important | note | tip | warning |
> literallayout | programlisting | programlistingco | screen | screenco |
> screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis |
> fieldsynopsis | constructorsynopsis | destructorsynopsis |
> methodsynopsis | formalpara | para | simpara | address | blockquote |
> graphic | graphicco | mediaobject | mediaobjectco | informalequation |
> informalexample | informalfigure | informaltable | equation | example |
> figure | table | msgset | procedure | sidebar | qandaset | anchor |
> bridgehead | remark | highlights | abstract | authorblurb | epigraph |
> indexterm | beginpage)+ , (sect1* | refentry* | simplesect* | section*))
> | sect1+ | refentry+ | simplesect+ | section+) , (toc | lot | index |
> glossary | bibliography)*), got (title sect1 sect1 refentry )
> Document /home/landley/linux/linux/Documentation/DocBook/80211.xml does
> not validate
> 
> Which means what, exactly?  (That particular example was from last week,
> it's been fixed since upstream.  I added --skip-validation to my xmlto
> invocation because more stuff built.  There are still two blank entries
> in http://kernel.org/doc/htmldocs/ are because their builds broke.  I
> should pull and run it again and see if those build now...)
> 
> Oh, another fun thing is that my Documentation index is created from the
> 00-INDEX files when those exist, and there's usually version skew
> between that file and the directory contents.
> 
> I have a http://kernel.org/doc/make/doclinkcheck.py which finds the
> files it lists which don't exist and the files which exist but aren't
> listed.  The current list of files 00-INDEX says exist, but aren't at
> that location, is:

I'll fix some of these (or accept patches to do so).
Thanks.

> 404 errors:
> Documentation/time_interpolators.txt
> Documentation/voyager.txt
> Documentation/powerpc/booting-without-of.txt
> Documentation/powerpc/mpc52xx-device-tree-bindings.txt
> Documentation/arm/msm
> Documentation/arm/Samsung-S3C24XX
> Documentation/arm/Sharp-LH
> Documentation/arm/SPEAr
> Documentation/arm/empeg/
> Documentation/PCI/PCI-DMA-mapping.txt
> Documentation/networking/dgrs.txt
> Documentation/networking/ethertap.txt
> Documentation/networking/wavelan.txt
> Documentation/w1/masters/mxc_w1
> Documentation/vm/slabinfo.c
> Documentation/serial/hayes-esp.txt
> Documentation/filesystems/dentry-locking.txt
> Documentation/filesystems/reiser4.txt
> Documentation/s390/zfcpdump
> 
> The list of files which exist but aren't in a 00-INDEX is crazy long so
> I won't post it here.  (I can if you're interested...)
> 
> I'll probably get around to chipping away at some of that, but first I
> need to do a proper 2010 OLS paper index.  (And that's just a
> chronological index.  A _topic_ index is a huge undertaking.  I did a
> quick search for the NFS guys last night and came up with 7 papers, and
> I haven't even checked 2010 yet.  I'm only even considering an OLS paper
> topic index because I'd only have to _update_ it once a year, so the
> work involved is at least finite...)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
