Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1I1Nun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:50:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1I1Num (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:50:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 14/24] C6X: traps
Date: Wed, 28 Sep 2011 15:50:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-15-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-15-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281550.40039.arnd@arndb.de>
X-Provags-ID: V02:K0:9Zqlfj8ZVfqQe306ekljSQtIs+ZTW2vL/YuLmvnucQJ
 Up5HKdBOvtWZvOK94CtE43eK5s8scAmHUE3MKCuRvo6R8AZlTy
 jwoeOVEhzAT+Nqk5ftOmTe4pRIJUnBEzrB4cpW6z7z/0fdMApt
 V0jVyJOWrqJ8Ci1Dbq924Tumzrg1YklMnvHW19ksNZG6wFAJvj
 rdBYprzxr/j8CeQ64VoaHwRlGeE8NhMYskCUn0EWetR1e4qMXW
 y6Bt1aCE7sJTfDwzZbrQIoJRkCRV1NtLPlr2UX3g7Gh7l7fjN+
 61EBqB04fetVhwdHAxS1YgAZ/9DgEnsaOGrCFN2dZwoKF4ZmiD
 EW5f4Oq9fpfqj32m4zD0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> 
> This patch provides the kernel entry points for traps, syscalls and
> interrupts.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
