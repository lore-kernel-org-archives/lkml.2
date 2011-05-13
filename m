Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab1EMPy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:54:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab1EMPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pMPRAhkZt9tHCZKU9vIDgpw7deDfHCxRag9kHXE8fmj9v116Ib4YrIF67Wt3SdIuPL
         3gvkQdnTHXvgWUM/fD1Q==
Message-ID: <4DCD542A.4010904@google.com>
Date: Fri, 13 May 2011 08:54:18 -0700
From: David Decotigny <decot@google.com>
Reply-To: david@decotigny.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Florian Weimer <fweimer@bfk.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: dl2k/stmmac patches (was Re: [PATCH 2/2] net/dl2k: Don't reconfigure
 link @100Mbps when disabling autoneg @1Gbps)
References: <1304986748-15809-1-git-send-email-decot@google.com>	<1304986748-15809-3-git-send-email-decot@google.com> <82y62dk1qz.fsf@mid.bfk.de>
In-Reply-To: <82y62dk1qz.fsf@mid.bfk.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi all,

An update on the patch series I posted earlier (dl2k/stmmac autoneg
minor changes: see my posts on 05/09/11 17:19 PST)...

I'd suggest dropping the patch concerning dl2k, as I don't have any way
to claim it's any good at all (though I'm pretty confident it doesn't
make things any worse).

However, for the other patch of the same series (stmmac), please
consider for inclusion the new version prepared by Giuseppe instead of
my initial patch, for his version readily integrates my patch and has
been tested on real hardware:
  stmmac: don't go through ethtool to start auto-negotiation
  stmmac: fix autoneg in set_pauseparam

Regards,
Thank you!

On 05/11/11 02:47, Florian Weimer wrote:
> * David Decotigny:
> 
>> Tested: module compiling, NOT tested on real hardware.
> 
> To my knowledge, dl2k is broken.  Some sort of synchronization
> primitives are missing.  Under load, the NIC's notion of ring buffer
> status diverges from the host's view. 8-(
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3NVCYACgkQld7vhusVrCHUEACggeKyCmoEHy9AzYec/aW8cDjU
GyAAoIiESxUAFWuKBmCOA31X/V0fvC+Y
=6hXY
-----END PGP SIGNATURE-----
