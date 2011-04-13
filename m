Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab1DMR1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:27:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36156 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab1DMR1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KlSRWi5U9dcSEKiOPnA6sEM0iRBNJ9CXxShT68qQ2vjp9ykV0KjZAEI3eJfGk1RjGb
         c7uNDTh+Z9A8tGevXzYZixB831NodKcNHt5UNtrIwm9txLX+zdKQiPBT+fl8JqtykG3q
         25yU4CIKStzp2rvisHTFEsdWq+bhkVxTXNfms=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104090936570.7873@ayla.of.borg>
References: <alpine.DEB.2.00.1104090936570.7873@ayla.of.borg>
Date: Wed, 13 Apr 2011 10:27:34 -0700
X-Google-Sender-Auth: 5INVGBG5jKIHH5PPoefgTVC4_II
Message-ID: <BANLkTikmDKcE5NwuatDQjdKkMouxnk6E4g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.39-rc2
From: Tony Luck <tony.luck@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  + warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A

What is the right way to fix this? Should ACPI_APEI "select
MISC_FILESYSTEMS" too?

-Tony
