Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0LYQBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 11:01:48 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:40467 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0LYQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 11:01:47 -0500
From: Eric Valette <eric.valette@free.fr>
Organization: Home
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
Date: Sat, 25 Dec 2010 16:58:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.5.3; x86_64; ; )
Cc: Felipe Balbi <me@felipebalbi.com>, Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, lud <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org> <4D145016.60906@free.fr> <AANLkTik9ByQpPCf3jNsotB__a_p3JxaiK7fA-E-K91U3@mail.gmail.com>
In-Reply-To: <AANLkTik9ByQpPCf3jNsotB__a_p3JxaiK7fA-E-K91U3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012251658.25928.eric.valette@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010 00:42:58 Alessandro Suardi wrote:

> > No. Mine has an Intel WiFi chipset. With DELL the same reference can be
> > used for multiple different hardware instantiation (I have a nvidia vido
> > chipset some seems now to have an intel one).
> > 
> Just as a data point, my Dell E6400 still shuts down fine in both
> 2.6.37-rc7 and -rc7-git2. This one has integrated Intel video (i915) and I
> use the out-of-tree broadcom-sta driver for the wireless interface. If
> needed, I can post my .config in the bugzilla entry (but won't, unless
> asked - in order to avoid possible bug noise).


That illustrates if needed the DELL reference multiple hardware problem. I put 
2.6.37-rc7 (git1/git2) on my personnal laptop and I do not experience the 
shutdown problem either.

I hope the problem is rare enough as I cannot supply more information before 
getting back to work.

-- eric
