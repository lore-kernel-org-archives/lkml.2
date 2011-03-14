Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1CNBiC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:38:02 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:55832 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744Ab1CNBh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:37:59 -0400
X-AuditID: 1209190f-b7c1dae000000a2b-2a-4d7d7176678b
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
X-Priority: 3 (Normal)
In-Reply-To: <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
Date: Sun, 13 Mar 2011 21:37:44 -0400
Cc: "Jeff Garzik" <jeff@garzik.org>, "Ric Wheeler" <ricwheeler@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>, "Sage Weil" <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Jonathan Nieder" <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
Content-Transfer-Encoding: 7bit
Message-Id: <FB72B156-6DF9-413B-98F2-D23A449E9303@mit.edu>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <4D7AC0FE.8070806@gmail.com> <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl> <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl> <4D7BBC03.3020404@garzik.org> <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
To: "Indan Zupancic" <indan@nul.nu>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 13, 2011, at 9:31 PM, Indan Zupancic wrote:

> The new syscall works on only one fd too. The behaviour of the proposed
> syncfs and an extended sync_file_range is exactly the same.

No, it's quite different.   One syncs the entire file system; sync_file_range
requests that the pages associated with a file be pushed to disk --- it says
nothing about the metadata associated with the file.

I'm in favor of the new sys_syncfs system call.

-- Ted

