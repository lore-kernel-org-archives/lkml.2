Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0HaM6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:58:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33283 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab0HaM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:58:31 -0400
Date: Tue, 31 Aug 2010 14:58:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Prabhu Chawandi <prabhu.chavandi@gmail.com>, linux-kernel@vger.kernel.org,
        listar@nl.linux.org
Subject: Re: increasing memory alloted for 'init' during kernel boot.
Message-ID: <20100831125830.GA14848@merkur.ravnborg.org>
References: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com> <4C7CBBBC.3070503@gmail.com> <AANLkTiniKYm7krr1j48VbV7oNDA7YKXzTnuCZ9kOMnUs@mail.gmail.com> <4C7CFAEA.2040408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7CFAEA.2040408@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:51:54PM +0200, Jiri Slaby wrote:
> On 08/31/2010 10:43 AM, Prabhu Chawandi wrote:
> > Hi ,
> > 
> > Thanks for the info...
> > 
> > Problem I am facing is, I have two bootloaders, when I boot from one
> > loader booting happens properly.
> > 
> > but when I try to load from other loader, kernel does not boot, it
> > crashes. When i saw the boot logs, I saw that I memory allocated to
> > 'init' section in case of crash is short by almost 5MB to the normal
> > boot log.
> > 
> > I am using mips processor.
> > 
> > Any idea, why this might be happening ?
> 
> The bad loader probably loads the image wrong (incorrect data or not
> whole image).

Shmulik just posted a patch that may be related.
See: "MIPS: Calculate VMLINUZ_LOAD_ADDRESS based on the length of vmlinux.bin"

Looks like a bug I have introduced btw :-(

	Sam
