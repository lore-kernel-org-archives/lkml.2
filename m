Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1BAE53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 23:57:29 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:46095 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1BAE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 23:57:28 -0500
Message-ID: <4D4792B2.60901@afaics.de>
Date: Tue, 01 Feb 2011 05:57:22 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37, reiserfs: Null pointer dereference at shutdown time
References: <4D4508A0.1080200@afaics.de>
In-Reply-To: <4D4508A0.1080200@afaics.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/30/11 07:43, Harald Dunkel wrote:
> I got a kernel dump at umount time of a huge reiserfs partition.
> It said
> 
> 	Null pointer dereference at 0000000000000010
> 	IP: [ffffffffa01dc818] open_xa_dir+0x2d/0x1b0 [reiserfs]
> 	:

Filed on https://bugzilla.kernel.org/show_bug.cgi?id=27972


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1Hkq0ACgkQUTlbRTxpHjeQlACdHrrOR9w2nvWTn2R3Bridpy/I
sgwAn3ooAtF+obfhZMgKalF9Ff9CxIZ0
=Qx/U
-----END PGP SIGNATURE-----
