Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2INDvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:51:15 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46476 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279Ab2INDu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:50:58 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: joeyli <jlee@suse.com>
To: Peter Jones <pjones@redhat.com>
Cc: jeremy.kerr@canonical.com, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Domsch <Matt_Domsch@Dell.com>, glin@suse.com
In-Reply-To: <1347544333.6707.1.camel@eddie.install.bos.redhat.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
	 <1347523843.596.30.camel@linux-s257.site>
	 <1347544333.6707.1.camel@eddie.install.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 11:45:42 +0800
Message-ID: <1347594342.705.33.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, 

於 四，2012-09-13 於 09:52 -0400，Peter Jones 提到：
> On Thu, 2012-09-13 at 16:10 +0800, joeyli wrote:
> 
> > Do we have plan to create a new kobject add to /sys/firmware/efi for
> > provide a fixed mount point to efivars fs?
> > e.g. /sys/firmware/efi/efivars
> > 
> > Or we just direct reuse current /sys/firmeware/efi/vars? But, that means
> > we need think for the backward compatibility if choice reuse vars
> > folder.
> 
> I'm not sure that's a terribly large concern - if you haven't updated
> your tools to use the new efivars, don't mount the new efivars.
> 

Thanks for your comment!

Joey Lee

