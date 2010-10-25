Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0JYV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:26:18 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:39307 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053Ab0JYV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:26:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAAOTxUxLd/sX/2dsb2JhbAAHgxjMFZIpgSKDMnQEj1Q
X-IronPort-AV: E=Sophos;i="4.58,237,1286164800"; 
   d="scan'208";a="80664937"
Message-ID: <4CC5F5F5.3060503@teksavvy.com>
Date: Mon, 25 Oct 2010 17:26:13 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>	<4CC24186.1040001@teksavvy.com>	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>	<4CC2FD0A.9090409@teksavvy.com>	<AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>	<4CC303FD.1000802@teksavvy.com>	<AANLkTin9wiBZjkeKxYKnJaSA1vxs8ELGTWYVMM1DfYKu@mail.gmail.com> <AANLkTikzPgq0VG1V_hZsw78i2pYMxzrPJM3dFUyGeaU1@mail.gmail.com>
In-Reply-To: <AANLkTikzPgq0VG1V_hZsw78i2pYMxzrPJM3dFUyGeaU1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-24 08:52 AM, Mathias Burén wrote:
>
> My question is, is it safe for me to stop md0, delete all 4 partitions
> that make up md0, recreate them at the same starting sector, but
> ending 2GB from the last sector? Is this safe, will I lose any data?
> Just in case I've backuped the MBR (first 512 bytes) of each HDD that
> has the partition.
..

Dunno.  I'm no RAID expert.  :)
