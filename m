Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2HNJcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:32:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2HNJct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:32:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: wei_wang@realsil.com.cn
Subject: Re: [PATCH 1/2] drivers/mfd: Add realtek pcie card reader driver
Date: Tue, 14 Aug 2012 09:32:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, sameo@linux.intel.com, bp@alien8.de
References: <1344922213-19581-1-git-send-email-wei_wang@realsil.com.cn>
In-Reply-To: <1344922213-19581-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208140932.27276.arnd@arndb.de>
X-Provags-ID: V02:K0:2EWLEaj567UAc2OIIwMqMipx1Y9wMQfssciNc3CNPWE
 OdgATg2h++1TTEeUXbjvp84twuEd1D1xSwZV6WeHu1+WglhKbf
 x6A0eWa53D12eHBRqzVuKD1pdOwvB7UDZjHgZisueJXLuEkh3M
 m+pwKSEIiQJoNxhW/yiTHL2MJJYMcwSECC4DdhxwrKicRwGJ3O
 yCC7Kdd/uB5pvZm+8wCCN4QGnjFvhMvHsPtbT9RgAAYXf7W/zd
 OKG7I7/VtevZ4kmjOC95gx3KnExcNNq/QdXacecElpniZERuR8
 rcT3Pg5Yb1rgotR4Ecfru9j/HLDtdhzIAc+J1BpdYGcutrxV3K
 REtnMcgDdZipM7LO1hEU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek PCI-E card reader driver adapts requests from upper-level
> sdmmc/memstick layer to the real physical card reader.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

When you post a new version of patches, please add a version number in the
subject line, like " [PATCH v3 1/2] drivers/mfd: Add realtek pcie card
reader driver", to make it easier for people to know what has changed.
It's also helpful to have a "[PATCH 0/XX]" as 'git format-patch
--cover-letter' generates and list the changes to the previous versions
of your patch in there. Best combine this with 'git send-email --thread
--no-chain-reply', so all patches are sent in the same email thread as
the introductory mail.

Finally, when you get an 'Acked-by' or 'Reviewed-by' tag from someone,
please add that below your Signed-off-by.

Your patches both look fine now, so you can add my

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
