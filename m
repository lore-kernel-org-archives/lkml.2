Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1FZWhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:37:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1FZWgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:36:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Subject: Re: [Bug #37542] [OOPS] 3.0-rc1 cifs
Date: Mon, 27 Jun 2011 00:37:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jeff Layton <jlayton@redhat.com>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.hZD.lZ6BOB@chimera> <Pine.LNX.4.64.1106262355030.6287@sarijopen.student.utwente.nl>
In-Reply-To: <Pine.LNX.4.64.1106262355030.6287@sarijopen.student.utwente.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270037.47322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011, Martijn Uffing wrote:
> Ave
> 
> The OOPS/BUG is fixed by 2 patches. Both patches are already included in 
> the linus git tree.
> 
> A patch for the separate issue to demote the superfluous kernel messages 
> from error to debug level is available, but not yet included in linus git.
> I will track this patch and ping the author if it isn't included in one of 
> the final rc's.
> 
> As far as I am concerned, this bug can be removed from the regression 
> list.

Cool, thanks, closing.

Rafael
