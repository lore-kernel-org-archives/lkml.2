Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2D3N5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:57:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2D3N5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:57:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] asm-generic: Use __BITS_PER_LONG in statfs.h
Date: Mon, 30 Apr 2012 13:57:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
References: <1335465916-16965-1-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1335465916-16965-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301357.11706.arnd@arndb.de>
X-Provags-ID: V02:K0:+nQaqyEqZg9rQKvgFjOsdL891tOccGVedUcVTh7FvZG
 dIe6z6w0XV4XbCwRM1ZAYLNZBY36SyrMGjEfP+w8DcdpVVOfHu
 St4YYAqsebu6uSjg6S3w0TPD3fRDzienYHhkWA6EbNk8DkwOt3
 9Sz8c1RLvENF4tr4MLzKeL8IxNMBHQcZV10iJWurhsPFqrWwrS
 Nd8vDNmCqLOFnkIhbk407AxHEg4muuXPbu9VxJNAey95rBk3xQ
 pR98b+vyjY9ef+r3gKIaiXe9vm2nfEIBblu574v7XjrqKL33EA
 8LFxM5KbuwOG+Yk0lRfDcIGpbkSY2eKX6DTDKrcVQjr6GckSeK
 8IlVQtVZMZW0Pc7QraLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2012, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> <asm-generic/statfs.h> is exported to userspace, so using
> BITS_PER_LONG is invalid.  We need to use __BITS_PER_LONG instead.
> 
> This is kernel bugzilla 43165.

Acked-by: Arnd Bergmann <arnd@arndb.de>
