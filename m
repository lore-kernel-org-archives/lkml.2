Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HPQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:54:55 -0400
Received: from masquerade.micron.com ([137.201.242.130]:8192 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1HPQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:54:54 -0400
Message-ID: <4E4AA0AD.7090109@micron.com>
Date: Tue, 16 Aug 2011 10:54:05 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v3 3/3] drivers/block/mtip32xx: Adding Makefile and Kconfig
References: <22A973199D2C2F46933448F6E7990A3002C80029@ntxboimbx31.micron.com> <20110811224725.GB10182@infradead.org>
In-Reply-To: <20110811224725.GB10182@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--8.367800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2011 4:47 PM, Christoph Hellwig wrote:
> I think the driver at least needs to depend on PCI.

Actually we should depend on pciehp module. I ran into some issue (in
kernel 2.6.39) when introducing the dependency, and removed the
dependency temporarily. I will check again with the current kernel.

-- 
Regards,
Asai Thambi
