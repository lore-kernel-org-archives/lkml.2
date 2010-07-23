Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab0GWOEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:04:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0GWOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:04:13 -0400
Date: Fri, 23 Jul 2010 16:03:43 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100723140343.GA8478@fancy-poultry.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:6IY2yIgUzr1jgqu3aHTdm5HUlu8xJNnQcrBzjbCF1Li
 p3MxrOehZ3Fg6os2yHeZYrwAbIFBl6a2tFAKHSC+FKyAIlEVza
 ctfERzq7daPqWK9/gtO+vnwZ5wQAE6JUdPzLjn0XCmTMfckyj+
 9rSoR9OfrrbzuigfXyHs3nIbpZimvdALnthLvvb46t5QgPengb
 /lRD4HVVdZAU8moNLU2IA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2010, Vivek Goyal wrote: 

> This is V4 of the patchset which implements a new tunable group_idle and also
> implements IOPS mode for group fairness. Following are changes since V3.
[....]

Just for information: this patchset, applied to 2.6.35-rc6, gives about
20-25% increase in speed/throughput on my desktop system 
(Phenom 2.5GHz Quadcore, 3 disks) with the tunables set according 
to what you've used/reported here (the setup with slice_idle set to 0),
and it's measurable with fs_mark, too.

After 2 hours of hard testing, the machine remains stable and responsive.

