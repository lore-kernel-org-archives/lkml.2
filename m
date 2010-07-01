Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab0GAUrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:47:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36737 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab0GAUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BpiK2mLURKr1HLRy7SaZgN8m6gA5K03ThSQ8huaBSSOMehLoE5XnEGvpJfQ8Kq9if6
         d32u7xnms5AtD2tggj/gM06CO+MdP9MAVT0hsJFio0QJ/PTDgzI1znMUGbs/OAL005Gs
         x68hJcWxibWYtiveXMEA0W6XY5sJAjUIaCVaI=
Subject: Re: Provide /sys/../ec with read/write access and some cleanups
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de
In-Reply-To: <1277996570-2686-1-git-send-email-trenn@suse.de>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 23:47:13 +0300
Message-ID: <1278017233.7029.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 17:02 +0200, Thomas Renninger wrote:
> These patches are diffed against the test branch of the ACPI tree, but also
> patch fine with 2.6.35-rc3.
> 
> I thought about tainting the kernel if someone writes to the EC, but as
> userspace can also write to graphics IO, PCI config or MSRs, it shouldn't
> matter that much.
> Eventually this should still be added (by a separate patch), one can easily
> confuse the EC to not switch on the fans anymore.
> 
> A small tool to read out and write to /sys/devices/system/ec/*/io can be
> found here:
> ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
> 
> Len: Can you apply these into your test branch and schedule them for linux-next
> and 2.6.36 if there are no objections, please.
> 
> Thanks,
> 
>      Thomas

This is great patchset, I was even thinking doing that myself.

While at it, could you also provide a broken down table of EC GPEs like
the one in /sys/firmware/acpi/interrupts/ ?

Best regards,
	Maxim Levitsky

