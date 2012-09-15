Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2IOCbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:31:41 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:60503 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2IOCbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:31:39 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: joeyli <jlee@suse.com>
To: jeremy.kerr@canonical.com
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>,
        Peter Jones <pjones@redhat.com>, jlee@suse.com,
        jeremy.kerr@canonical.com
In-Reply-To: <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Sep 2012 10:26:23 +0800
Message-ID: <1347675983.705.54.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2012-09-11 於 15:23 +0800，lee joey 提到：
> From: Matthew Garrett <mjg@redhat.com>
> 
> The existing EFI variables code only supports variables of up to 1024
> bytes. This limitation existed in version 0.99 of the EFI
> specification,
> but was removed before any full releases. Since variables can now be
> larger than a single page, sysfs isn't the best interface for this.
> So,
> instead, let's add a filesystem. Variables can be read, written and
> created, with the first 4 bytes of each variable representing its UEFI
> attributes. The create() method doesn't actually commit to flash since
> zero-length variables can't exist per-spec.
> 
> Updates from Jeremy Kerr <jeremy.kerr@canonical.com>.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com> 

I and Gary tested create, update, delete unauthenticated variable, works
fine.

Tested-by: Lee, Chun-Yi <jlee@suse.com>


Thanks a lot!
Joey Lee

