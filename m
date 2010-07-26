Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0GZQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:15:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0GZQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:15:12 -0400
Date: Mon, 26 Jul 2010 18:15:00 +0200
From: Heinz Diehl <htd@fritha.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100726161500.GA8721@fritha.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
 <20100726134329.GB12449@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726134329.GB12449@redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:DLwHuB/2A6qDl8sEy7y+RvwGuoebIt4somkzFRFJZSz
 VjmA0bhjEq/ygoN82hFCKPyauhAIJgAZT5AQfgBXi2ApLhQi6E
 QqGhvcAjQGsmndVpm4+EIzZe+su3F9a6mQoN5rf5UdcfOSTVIv
 KMDwgEYfZpvj5kYTn2HVCgCzss+Bz3fh5pqetWssmPkc9j1cPO
 d5I8I33kUZBYnnkv3hF4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.2010, Vivek Goyal wrote: 

> How do you measure it? IOW, are you running something else also on the
> desktop in the background. Like a heavy writer etc and then measuring
> how interactive desktop feels?

I used Linus' "bigfile torture test" in the background:

 while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ;
 sync; rm bigfile"; done

and Theodore Tso's "fsync-tester" to benchmark interactivity. 

Didn't save any results, wasn't expecting that this could be of any
further interest (but can run the tests one more time, if desired).

Thanks,
Heinz.
