Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab1DMRbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:31:14 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60587 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932664Ab1DMRbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:31:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hAHzPwUpfRT6B7Efiyl3WYCwoRGynJYYWG4aNnEkEQTWfvDDMsasUZnQolmpE2P6USjtAdyqd/4kqTqUVGkfSyTwBjAa9+o4rakXlVVlF57kHqYhj579/EZAtw4nz5Wc;
Date: Wed, 13 Apr 2011 10:31:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.39-rc2
Message-Id: <20110413103109.76b9bb3d.rdunlap@xenotime.net>
In-Reply-To: <BANLkTikmDKcE5NwuatDQjdKkMouxnk6E4g@mail.gmail.com>
References: <alpine.DEB.2.00.1104090936570.7873@ayla.of.borg>
	<BANLkTikmDKcE5NwuatDQjdKkMouxnk6E4g@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 10:27:34 -0700 Tony Luck wrote:

> >  + warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A
> 
> What is the right way to fix this? Should ACPI_APEI "select
> MISC_FILESYSTEMS" too?

Yes.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
