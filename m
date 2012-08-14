Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2HNPBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:01:31 -0400
Received: from luna.vmars.tuwien.ac.at ([128.130.39.29]:52659 "EHLO
	mail.vmars.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2HNPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:01:30 -0400
Message-ID: <502A5B40.9010303@vmars.tuwien.ac.at>
Date: Tue, 14 Aug 2012 16:05:52 +0200
From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH V2 2/2] apple_gmux: Add support for newer hardware
References: <1344898369-4944-1-git-send-email-mjg@redhat.com> <1344898369-4944-2-git-send-email-mjg@redhat.com> <20120814004625.GB18992@thinkpad-t410>
In-Reply-To: <20120814004625.GB18992@thinkpad-t410>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please reduce the delay in the gmux_index_wait_[ready|complete]
functions: 100ms is way too long. 1 ms is more than enough. I never
experienced any problems with 100 us.

The version information can also be extracted in the new gmux device
(see my initial patch proposal).

Bernhard

On 08/14/2012 02:46 AM, Seth Forshee wrote:
> On Mon, Aug 13, 2012 at 06:52:49PM -0400, Matthew Garrett wrote:
>> New gmux devices have a different method for accessing the
>> registers. Update the driver to cope. Incorporates feedback from
>> Bernhard Froemel.
>> 
>> Signed-off-by: Matthew Garrett <mjg@redhat.com> Cc: Bernhard
>> Froemel <froemel@vmars.tuwien.ac.at> Cc: Seth Forshee
>> <seth.forshee@canonical.com>
> 
> Acked-by: Seth Forshee <seth.forshee@canonical.com>
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAqWz8ACgkQ6iVUjPs37Jny4QCgvIj24lw/hpSF35P3k7vKcxtt
xj4AoNdN4u1QE4YErj771aP2ArZMDOS1
=TJHi
-----END PGP SIGNATURE-----
