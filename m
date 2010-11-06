Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0KFI7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 04:59:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63547 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0KFI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 04:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rotWIYob9dfFIf5GmUmNt8q7UTwDZKlmpZCE7EqLLSAACk7dzT8/+PC9l2GJACjt7m
         +nAUbELDzI2cUyGeficfWTS0OGk5gXn3YOOC5LucybzrziBG9SCxrZHVXd7DZSAMgXSe
         jJVuQLAHIvyreFeyWt9mAgm2yg8kYeqTzJyYY=
Message-ID: <4CD5181C.7040706@gmail.com>
Date: Sat, 06 Nov 2010 09:55:56 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: [PATCH 00/16 v2] pramfs: persistent and protected RAM Filesystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I send the patch series again. I fix documentation problems reported by
Randy Dunlap and Kieran Bingham. I reworked the memory protection
functions according to the suggestions of Andi Kleen.

I ask to Andrew to evaluate to insert this fs in mainline.

Marco
