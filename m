Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1JCBc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:32:26 -0400
Received: from outmail148108.authsmtp.net ([62.13.148.108]:58330 "EHLO
	outmail148108.authsmtp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599Ab1JCBcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:32:19 -0400
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Oct 2011 21:32:19 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com>
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Sun, 02 Oct 2011 18:18:43 -0700
In-Reply-To: <4E8655CD.90107@zytor.com> (H. Peter Anvin's message of "Fri, 30
	Sep 2011 16:50:37 -0700")
Message-ID: <87zkhirhxo.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: 4fcc1602-ed5d-11e0-80b9-0022640b883e
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AThCFzNJTwsiPBEK DBMeOw5HJEYITQBc chwbOAIId3oXWRYD A2cKS1RWWlx3U2Fx JQ1XcwRZfE5GQQdq UldLR1BXCwQmQRUC B2lgOGFydA1EcX0+ YUBkXD5fChcpdEB9 QFMBQWhSeGZhPWAC WEAKfh5UcAFIeBtF OFh3VyZDAzANdiE1 BQk+O3Y2JzoXMzhc XhwWfxofWloCFDo9 XBADGzpnFAU9aB17 MBEsYlkSVFoLL14u WaW7
X-Authentic-SMTP: 61633331373532.1015:706
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> 5. Get as many other kernel developers that you have physical access to
>    to sign your key after verifying the fingerprint.  Verifying keys
>    over the phone is OK if and only if you know them *extremely* well;
>    think "would I be willing to testify in court that the person I
>    talked to was X"?

There is already an extensive Debian web of trust, and along with
it a keysigning coordination effort and even a long list of
Debian developers who offer to sign keys, with their physical
locations and email addresses:
        http://wiki.debian.org/Keysigning/Offers

I wonder whether either effort would benefit from joining forces?
I am also sure that there is overlap between Debian developers
and kernel developers.
-- 
Ben Pfaff 
http://benpfaff.org
