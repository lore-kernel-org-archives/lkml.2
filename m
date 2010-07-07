Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0GGQTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab0GGQTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:19:49 -0400
Message-ID: <4C34A922.6090705@kernel.org>
Date: Wed, 07 Jul 2010 18:19:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org>	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>	<4C317C04.20500@kernel.org>	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>	<4C32CE50.6010501@kernel.org>	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>	<4C341598.6040004@kernel.org>	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>	<4C34A1D5.1090202@kernel.org> <AANLkTikAENeTTHGiRO_tj3r0_rqXdFZ7KJDLYuIRpM-i@mail.gmail.com>
In-Reply-To: <AANLkTikAENeTTHGiRO_tj3r0_rqXdFZ7KJDLYuIRpM-i@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Jul 2010 16:19:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 06:15 PM, Mark Knecht wrote:
> Certainly. Is there a way to reverse the previous patch?
> 
> c2stable linux # patch -p1 --dry-run <~mark/Downloads/resume-dbg-1.patch
> patching file drivers/ata/libata-core.c
> Hunk #1 succeeded at 3798 (offset 86 lines).
> Hunk #2 succeeded at 3833 with fuzz 2 (offset 94 lines).
> Hunk #3 FAILED at 6109.
> 1 out of 3 hunks FAILED -- saving rejects to file drivers/ata/libata-core.c.rej
> c2stable linux #
> 
> I assume this is failing because your patch is over the plain kernel,
> not the one I've patched?

$ patch -R -p1 < ~mark/Downloads/resume-dbg.patch
$ patch -p1 < ~mark/Downloads/resume-dbg-1.patch

-- 
tejun
