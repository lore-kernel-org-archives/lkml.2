Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1JCBty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:49:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50485 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab1JCBts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:49:48 -0400
Message-ID: <4E8914AF.3060902@zytor.com>
Date: Sun, 02 Oct 2011 18:49:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Ben Pfaff <blp@cs.stanford.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <87zkhirhxo.fsf@blp.benpfaff.org>
In-Reply-To: <87zkhirhxo.fsf@blp.benpfaff.org>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 06:18 PM, Ben Pfaff wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> 5. Get as many other kernel developers that you have physical access to
>>    to sign your key after verifying the fingerprint.  Verifying keys
>>    over the phone is OK if and only if you know them *extremely* well;
>>    think "would I be willing to testify in court that the person I
>>    talked to was X"?
> 
> There is already an extensive Debian web of trust, and along with
> it a keysigning coordination effort and even a long list of
> Debian developers who offer to sign keys, with their physical
> locations and email addresses:
>         http://wiki.debian.org/Keysigning/Offers
> 
> I wonder whether either effort would benefit from joining forces?
> I am also sure that there is overlap between Debian developers
> and kernel developers.

There almost certainly is, and keep in mind that there isn't really "a
Debian web of trust" and "a kernel web of trust"... there is a "PGP web
of trust" as long as people upload their signatures to the shared
keyserver system.

	-hpaq

