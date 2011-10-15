Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1JOL40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 07:56:26 -0400
Received: from mailout.selfhost.de ([82.98.82.25]:37429 "EHLO
	mailout.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1JOL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 07:56:25 -0400
Message-ID: <4E9974E3.3080309@afaics.de>
Date: Sat, 15 Oct 2011 13:56:19 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0.6
References: <20111003203537.GC22113@kroah.com>
In-Reply-To: <20111003203537.GC22113@kroah.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/03/11 22:35, Greg KH wrote:
> I'm announcing the release of the 3.0.6 kernel.
> 
> There was a build error in the radeon driver of the 3.0.5 kernel, so this update is only needed if you have problems building that kernel.
> 
> The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE): git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

This seems to be broken. I get

fatal: http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git/info/refs
not found: did you run git update-server-info on the server?


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6ZdN4ACgkQUTlbRTxpHjedbACbBtAx/8j0INcVHRNthwGXX6FF
YxcAnjcOx3MeDYBv2cJ91yuVaJ4Y7nCs
=rfQb
-----END PGP SIGNATURE-----
