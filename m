Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2ILGfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:35:04 -0400
Received: from nm21-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.209]:48334 "HELO
	nm21-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753878Ab2ILGfA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:35:00 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2012 02:34:59 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 639213.23311.bm@omp1014.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Dq9XduXaFANTHVmF+S6oi6A7s0XpDS2PBf4VJaPkzXsSAnf/VU7qRe/1Qv5SJEitdAXyu9fsoUkcaFS+WI2fHpM3s5tBT3I1YVxLnnURuZhScn8cUbcwAuWtNLsXyUPYYzHMfNnBYNlPzmu6VoZo2mmOkY/utWrotCyI3w6OY9c=;
X-YMail-OSG: 4fnUgdcVM1kEc141mNivZQdEav0skl.dOnmXDj8xT8uuMfG
 3OW5FpxHMp1BUVCpmqXNNM8wYQj51MiswgeJYXuSuo9EI1wEKzVD_VRYYWCV
 rWIrqzz.H6LTLuM_L1BXEaQEtelNdlIHWN1vykZHtovKPxP_JZKdogHZr_Mu
 ApdPigKbhKr5xUadWHmEjiO48KcJCzWYnG_BMg6_E49GBE5dbSlx_5CCx59k
 J.Nn9HJHjTL2UI5SVRsdSWzxfDwW1EQGHlQagGhI3jj_j0h56OeDFWJQYIje
 HVtiUOdAKF1a261Aj3f91DLTygQgQclmTrRFZ3v7Laq5qjYAq2q87fAy7psZ
 8KJ2T43t1RfjqAKRTxqRT84rYUMHqjo16ROEm5yQH4UCceitieahYypSucXP
 2R6P4xeLoh4tjmDCEaMiUjjKiC5qCD6wOMKYoOL8uS3xs8p9Q.GybTmkztxE
 dPNgH1QgCI_6N.jjhueo0YRhBwSlvVlg-
X-Mailer: YahooMailWebService/0.8.121.416
References: <cover.1347330871.git.wei_wang@realsil.com.cn> <8e6b82eff5844d15612b196a53b28424f4c13c5c.1347330871.git.wei_wang@realsil.com.cn>
Message-ID: <1347431336.12833.YahooMailNeo@web121004.mail.ne1.yahoo.com>
Date: Tue, 11 Sep 2012 23:28:56 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH v6 3/3] drivers/memstick: Add realtek pcie memstick host driver
To: "wei_wang@realsil.com.cn" <wei_wang@realsil.com.cn>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>
In-Reply-To: <8e6b82eff5844d15612b196a53b28424f4c13c5c.1347330871.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 

> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek PCI-E Memstick card host driver is used to access Memstick
> card, with the help of Realtek PCI-E card reader MFD driver.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

Acked-by: Alex Dubov <oakad@yahoo.com>
