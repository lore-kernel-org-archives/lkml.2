Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab1EICPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:15:41 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45904 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932321Ab1EICPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:15:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rf8tG+Tx3XyWjcmxG/cneT8ulnQVRPrN/Juwf6rDhUNZsWV9e+9ebZInwxCNJZ5Dm9ViLMXQSEFYyj/2O9CsdCQwPpj+snhpDdXrxtDARsSlMD6JFEvtCzaOgElmhyjK;
Date: Sun, 8 May 2011 19:15:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Connor H <cmdkhh@gmail.com>
Cc: gene heskett <gheskett@wdtv.com>, linux-kernel@vger.kernel.org
Subject: Re: trying to build 2.6.38.5?
Message-Id: <20110508191536.ba3173d2.rdunlap@xenotime.net>
In-Reply-To: <BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com>
References: <201105082023.09878.gene.heskett@gmail.com>
	<20110508174528.24b0f0c2.rdunlap@xenotime.net>
	<201105082112.14959.gheskett@wdtv.com>
	<BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011 19:00:54 -0700 Connor H wrote:

> unable to reproduce using the included config file,
> 
> Connor

Nor can I.


> On Sun, May 8, 2011 at 6:12 PM, gene heskett <gheskett@wdtv.com> wrote:
> > On Sunday, May 08, 2011, Randy Dunlap wrote:
> >>On Sun, 8 May 2011 20:23:09 -0400 Gene Heskett wrote:
> >>> At the end of a make -j2 all:
> >>>
> >>> /home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: ***
> >>> commands commence before first target.  Stop.
> >>> make[2]: *** [linux] Error 2
> >>> make[2]: *** Waiting for unfinished jobs....
> >>> make[1]: *** [headers_install] Error 2
> >>> make: *** [vmlinux] Error 2
> >>>
> >>> What am I missing?
> >>
> >>I can't reproduce this problem.  Please post your kernel .config file.
> >>
> >
> > Attached, thanks Randy.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
