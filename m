Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2IMNwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2IMNwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:52:22 -0400
Message-ID: <1347544333.6707.1.camel@eddie.install.bos.redhat.com>
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: Peter Jones <pjones@redhat.com>
To: joeyli <jlee@suse.com>
Cc: jeremy.kerr@canonical.com, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Date: Thu, 13 Sep 2012 09:52:13 -0400
In-Reply-To: <1347523843.596.30.camel@linux-s257.site>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
	 <1347523843.596.30.camel@linux-s257.site>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 16:10 +0800, joeyli wrote:

> Do we have plan to create a new kobject add to /sys/firmware/efi for
> provide a fixed mount point to efivars fs?
> e.g. /sys/firmware/efi/efivars
> 
> Or we just direct reuse current /sys/firmeware/efi/vars? But, that means
> we need think for the backward compatibility if choice reuse vars
> folder.

I'm not sure that's a terribly large concern - if you haven't updated
your tools to use the new efivars, don't mount the new efivars.

-- 
  Peter

