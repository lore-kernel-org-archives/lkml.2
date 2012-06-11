Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2FKOKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:10:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2FKOKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:10:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH 3/4] bitops: Introduce generic set_bit_le()
Date: Mon, 11 Jun 2012 14:10:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp> <20120611213101.5969fde5.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120611213101.5969fde5.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111410.26359.arnd@arndb.de>
X-Provags-ID: V02:K0:3XaP5q4hHIjvvyxBOwV/xw6Md1Qxnlg4ivUb7vtJphv
 vA3BxQlU1VhIRSd7Z1z5a0EjCmoHKRMJjWisOefiY4cMvLG0FK
 aNTI6Dr9lJMHZHG+xSQxXpJYW3akw6n6If8fPjKZlXMW0kQcBq
 c3nwYBB1i5P79v4SB/tRQknSCjppDC/whkchWKiW+BG9O3KpsY
 9/AjDvhVoDbqdZ97B6sNj5gjrP9UX/IxqAaJsrYMgE45paC6eo
 ZObWkH5CYGSlJrfb8bugEMIZ1Eh87zPPNNhBYTqKJN5Tr9dss3
 dJqaiVP9k8K+62HNn/XrVxlYv2evQZsAXP5sB7SdeDKgT5BqL4
 /3MSojCJ58bfBeQ8Zljg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Takuya Yoshikawa wrote:
> From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> 
> Needed to replace test_and_set_bit_le() in virt/kvm/kvm_main.c which is
> being used for this missing function.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Cc: Arnd Bergmann <arnd@arndb.de>

I would recommend adding the corresponding clear_bit_le() along with
set_bit_le, so the next person who needs that doesn't have to make
yet another patch.

	Arnd
