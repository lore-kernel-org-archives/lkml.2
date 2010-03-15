Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337Ab0COQSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:18:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237Ab0COQSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:18:36 -0400
Message-ID: <4B9E5D82.6020101@redhat.com>
Date: Mon, 15 Mar 2010 09:17:06 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, travis@sgi.com, peterz@infradead.org,
       rja@sgi.com, sharyath@in.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: sched_getaffinity(): Allow less than
 NR_CPUS length
References: <20100312161316.9520.A69D9226@jp.fujitsu.com> <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org> <20100315160454.GA8211@sgi.com>
In-Reply-To: <20100315160454.GA8211@sgi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/15/2010 09:04 AM, Jack Steiner wrote:
> I'm running on a distro kernel that has NR_CPUS=4096.  Glibc has also has a
> definition of __CPU_SETSIZE (I assume this change was made by the distro but
> am not certain):

This isn't upstream and it cannot.  Whoever make this change doesn't
know what binary compatibility means.  The size has always been 1024 bits.

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkueXYIACgkQ2ijCOnn/RHQJPQCbBvh+Mi7ZrHaQcVxEkglIj+Pz
j7UAoJaBCpD2a5KbAR1VGkM7orp+GBhY
=T78A
-----END PGP SIGNATURE-----
