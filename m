Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909Ab0GTBOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 21:14:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17395 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab0GTBOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 21:14:42 -0400
Date: Mon, 19 Jul 2010 18:12:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Kees Bakker <kees.bakker@xs4all.nl>, Keith Packard <keithp@keithp.com>
Subject: [git pull] documentation: fix almost duplicate filenames
 (io/IO-mapping.txt)
Message-Id: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C44F859.025F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from
	git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs/ #linuxdocs

for one changeset:

commit c4eb8054dc4298c588658579622ac095bce86473
Author: Randy Dunlap <rdunlap@hera.kernel.org>
Date:   Mon Jul 19 22:20:27 2010 +0000

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



---
(hopefully I got this right.  I'm not a big git user.)
