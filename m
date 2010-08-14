Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab0HNEQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 00:16:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49487 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0HNEQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 00:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=cUxpoN/G8mxY6Fpb9nOC7raEIF312TuP7MAWWhmyJOp9Pvfvv38KMMmnWfr6tHZcj/
         OlVZ9r/SXHSm34+MxPIJadVhpic91VDWebyLCg4T/1Zv7bhTvocDyF5GuT9NJhy5ch5d
         neBJE9hXbgFFItSYyFvv8Wq9HpUt/BB00DG2M=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Cyril Hrubis <metan@ucw.cz>
Subject: Re: zaurus pata_pcmcia corrupted filesystem
Date: Sat, 14 Aug 2010 06:16:03 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Robert Hancock <hancockrwd@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jeff Garzik <jgarzik@pobox.com>, pavel@ucw.cz, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, thommycheck@gmail.com,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <20100811144410.GA12029@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100811144410.GA12029@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008140616.04034.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 11. srpna 2010 16:44:11 Cyril Hrubis napsal(a):
> Hi!
> Marek Vasut ported deprecated zaurus pcmcia disk driver to the pata_pcmcia
> interface, sources are here:
> 
> http://git.kernel.org/?p=linux/kernel/git/marex/pxa-linux-2.6.git;a=shortlo
> g;h=refs/heads/zaurus-haxing
> 
> Everythig seems to be fine at the first look but sometimes the filesystem
> gets unconsistent. Typical example is extracting tar archive with big
> number of files and directories (I used ltp-full archive from
> http://www.sf.net/projects/ltp/). After doing that, some files or
> directories are present in the filesystem, eg. you can see them in
> directory listing but open or fstat returns ENOENT.
> 
> Extracting to SD card seems to work without any problems.
> 
> Anybody has idea what went wrong?

I use the pcmcia on a few devices and was unable to replicate it (and I use git 
and do some heavy compiling on them too). I'll do some further testing.

Cyril, do you have the PCMCIA timing fix for PXA applied?
