Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1CAXRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:17:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1CAXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:17:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-config tree with the tty tree
Date: Wed, 2 Mar 2011 00:16:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
References: <20110228174007.b6faf01e.sfr@canb.auug.org.au> <201103012324.27725.arnd@arndb.de> <20110302101357.7d2a3d81.sfr@canb.auug.org.au>
In-Reply-To: <20110302101357.7d2a3d81.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103020016.53993.arnd@arndb.de>
X-Provags-ID: V02:K0:Quwe/jiFlu1d22t6phjY3LEhCa95zoe309Ce7/Q6YUN
 lGXlwy3oDnHAbmFJqR3Tdrix8iF/9gFMbR5Oq2e6AwWaoW6k85
 D1vIjbm5acGgJbY0iaDsVxzm4s0tdRaxZkH6vZIzI2mhIXckN+
 SV7YZf87WutgcAVXumOJHFLuuTJoDZIuf6JagX2xHDr/SZAQ77
 UWE/p6qiYkRBossQF18/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011 00:13:57 Stephen Rothwell wrote:
> On Tue, 1 Mar 2011 23:24:27 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I have cleared the branch in my repository now, since the contents
> > were very outdated. I have a newer branch named 'final' with all the patches
> > that are needed on top of -next to kill the BKL for good.
> 
> Thanks for that.
>
> > I'll send the patches out for review again and if everyone is happy,
> > I can update the config branch so they get into -next.

Small update: I've added part of the series to the config branch
already, just the patches that already have Acked-by:s from the
maintainers, but no other tree to go through.
 
> So can I remove the bkl-trivial, bkl-llseek and bkl-vfs trees?

Yes.

	Arnd
