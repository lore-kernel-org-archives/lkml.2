Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0GTPko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:40:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35636 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0GTPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:40:42 -0400
Message-ID: <4C45C33C.9090907@oracle.com>
Date: Tue, 20 Jul 2010 08:39:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Kees Bakker <kees.bakker@xs4all.nl>,
        Keith Packard <keithp@keithp.com>
Subject: [git pull v2] documentation: fix almost duplicate filenames  (io/IO-mapping.txt)
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com> <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
In-Reply-To: <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C45C350.0209:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from
	git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs/ #linuxdocs

for one changeset:

commit f0e4984f0df34e344809c35387d895b57eab5dcc
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Jul 19 22:20:27 2010 +0000

    Subject: documentation: fix almost duplicate filenames (IO/io-mapping.txt)
    From: Randy Dunlap <randy.dunlap@oracle.com>
    
    Having both IO-mapping.txt and io-mapping.txt in Documentation/
    was confusing and/or bothersome to some people, so rename
    IO-mapping.txt to bus-virt-phys-mapping.txt.  Also update
    Documentation/00-INDEX for both of these files.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
patch summary:

 Documentation/00-INDEX                             |    6 ++++--
 .../{IO-mapping.txt => bus-virt-phys-mapping.txt}  |    0
 2 files changed, 4 insertions(+), 2 deletions(-)
 rename Documentation/{IO-mapping.txt => bus-virt-phys-mapping.txt} (100%)


and thanks for your help.
