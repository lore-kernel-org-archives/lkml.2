Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FBGHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 02:07:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56782 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab1FBGHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 02:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nfW3R6YlUPAhZS8dCG68lyUdzr/7bjg1fBV9kuZohPTSnPiZ8AQeIKRGavnPDv+Pvw
         0UONU8Oj44TKBCuU3cgTnnM2TdmWM2t/2MpzXL/+oeLts2vLrmdBiorOMcUrTFLVaCsx
         S5eYew+0b9fNdLDU7EkEBksGcQkyzRTgcNfvg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	<alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
Date: Thu, 2 Jun 2011 08:07:17 +0200
Message-ID: <BANLkTi=JRDrzn=-d8jVqZLPGtV1osa1eiw@mail.gmail.com>
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, linville@tuxdriver.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 at 16:50, Christian Kujau wrote:
> trying to boot 3.0-rc1 on powerpc32 only progresses until:
>
>   > Kernel virtual memory layout:
>   >   * 0xfffcf000..0xfffff000  : fixmap

The weird thing is that:

1) You didn't see (like Andres):
Machine check in kernel mode.
 Caused by (from SRR1=149030): Transfer error ack signal
 Oops: Machine check, sig: 7 [#1]
But, OK, maybe machine check requires something additional in kernel,
I don't know...

2) You didn't see SSB messages
This is confusing. You should see SSB messages that appear before my
invalid read happens. Did you somehow disable most of the important
logs, or sth? Having ssb messages and the end of hung boot would
directly point you to ssb module.

-- 
Rafał
