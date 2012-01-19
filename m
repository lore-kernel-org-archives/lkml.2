Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2ASOGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:06:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2ASOGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:06:37 -0500
Message-ID: <4F182364.6090503@redhat.com>
Date: Thu, 19 Jan 2012 14:06:28 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] (no subject)
References: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
In-Reply-To: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/19/2012 01:00 PM, Kasatkin, Dmitry wrote:
> Hi,
> 
> I rebased on the stop of latest mainline tree and now dmsetup
> fails... It says: "Failed to create notification semaphore:
> Function not implemented". I run strace and saw that dmsetup uses
> "semget" which returns -ENOSYS...
> 
> Any ideas?

Do you have SysV IPC turned on in kconfig (CONFIG_SYSVIPC and
CONFIG_SYSVIPC_COMPAT if using 32-bit compat ioctls)?

Regards,
Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8YI2MACgkQ6YSQoMYUY97KrgCgyi6qwG2kF6gGFh9tPZYpIvrN
RbQAoKck78dZdCPpOXeI92NFM8cjyIy2
=LsuP
-----END PGP SIGNATURE-----
