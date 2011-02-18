Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1BRC4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:56:07 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45074 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1BRC4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:56:04 -0500
Date: Fri, 18 Feb 2011 11:56:01 +0900
From: Norbert Preining <preining@logic.at>
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression 2.6.38-rc4 -> 2.6.38-rc5 suspend fails
Message-ID: <20110218025601.GA30118@gamma.logic.tuwien.ac.at>
References: <20110217163300.GA7988@gamma.logic.tuwien.ac.at> <201102172309.26106.rwys@fuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102172309.26106.rwys@fuw.edu.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 17 Feb 2011, R. J. Wysocki wrote:
> > [  187.431895] sd 0:0:0:0: [sda] Stopping disk
> > [  187.480078] tpm_tis 00:0a: Operation Timed out
> > [  187.480095] legacy_suspend(): pnp_bus_suspend+0x0/0x6a returns -62
> > [  187.480101] PM: Device 00:0a failed to suspend: error -62

> What happens if you revert commit 9b29050 (tpm_tis: Use timeouts returned from TPM)?

Reverting this commit the laptop suspends fine again.

Thanks.

If you need any other testing, please let me know.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`Maybe somebody here tipped off the Galactic Police,' said
Trillian. `Everybody saw you come in.'
`You mean they want to arrest me over the phone?' said
Zaphod, `Could be. I'm a pretty dangerous dude when I'm
cornered.'
`Yeah,' said a voice from under the table [Ford's now
completely rat- arsed at this point], `you go to pieces so
fast people get hit by the shrapnel.'
                 --- Zaphod getting paranoid over a phone call.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
