Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0IXGal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:30:41 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:2079 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137Ab0IXGaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:30:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABfim0xLd/sX/2dsb2JhbAAHgxTTM5IngSKDLXME
X-IronPort-AV: E=Sophos;i="4.57,227,1283745600"; 
   d="scan'208";a="76606422"
Message-ID: <4C9C458D.3080703@teksavvy.com>
Date: Fri, 24 Sep 2010 02:30:37 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: hdparm-9.32 released: recommended upgrade
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com> <4C9C37B7.7060204@teksavvy.com>
In-Reply-To: <4C9C37B7.7060204@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-24 01:31 AM, Mark Lord wrote:

> hdparm-9.31 is now released, with some fixes to --security,
> and with the nasty warnings mostly removed.

And quickly followed by hdparm-9.32.  Upgrade is RECOMMENDED.

Apparently a number of commands in hdparm have been b0rked since 9.27+,
but nobody bothered to email me about them.  Doh!

Fixed.

(but the libata/libahci AHCI result_tf problem is still an issue).
