Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab0HNIck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:32:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab0HNIci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oz1UsFL2gd22ymE0DVq9ajwFmWG2CmyVIanVb9wjdGq26s9CXQM6dpL8K668FIR78P
         E/3ogvEmZNnZL24+GdLnhw8dJhfrsqzUzizfWmAFsd3YVG+CRg6mIlYZnrUB6ydU9p3x
         mMLMdQkORwHfFOB4nFGdJVNeIMgEQ5uqLzF+k=
MIME-Version: 1.0
Date: Sat, 14 Aug 2010 13:04:47 +0530
Message-ID: <AANLkTin_RGNrWvR3puCxxJQRtwjM=G6vzv5MiTymK4Q7@mail.gmail.com>
Subject: Unknown symbol apic (err 0) for apic_read/apic_write
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If we try to access following functions by modules for X86_LOCAL_APIC
we will get "Unknown symbol apic (err 0)" for :

apic_read()
apic_write()
apic_icr_read()
apic_icr_write()
apic_wait_icr_idle()
safe_apic_wait_icr_idle()

Thanks,
--
Jaswinder Singh.
