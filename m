Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0C1Vhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:37:34 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:34830 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0C1Vhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=UtNHMPFCfQie/iEo9VyF8dINDXaxShntzdSxn2ilsi/J4S17flMvXpJ1eMilEjpLnu
         4sn7IBoypkAWaTZQBkGHTdVWT1xOQWrjwYzdECXRzNqTi3tgGMwMAS55Gm5rhOa7aZmO
         KG+DWANN0Wbgkt1fr6l4DWrpZTVXj1aVfNMFw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Fries <david@fries.net>
Subject: Re: revert request "ide: skip probe if there are no devices on the port (v2)"
Date: Sun, 28 Mar 2010 23:37:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20100328212728.GA2674@spacedout.fries.net>
In-Reply-To: <20100328212728.GA2674@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003282337.01747.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 March 2010 11:27:28 pm David Fries wrote:
> Now that I have 2.6.34-rc2 booting it no longer detects the cdrom
> drive.  That is looking at the kernel messages, partition dump, and
> after booting hdparm etc does not find the drive.  I expect it is
> because the cdrom is a slave drive without a master on that ribbon.
> Reverting
> -------------------------------
> commit a20b2a44eca52818ef52a94959480b7e6ea2f528
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Mon Jun 8 22:07:28 2009 +0200

It was reported to upstream maintainer on 2009-10-18.

https://bugzilla.kernel.org/show_bug.cgi?id=14438

PS Please do not cc: me on upstream kernel problems, I don't have any
time to work on them (maintainer change happened on Jun 21 2009)..

--
Bartlomiej Zolnierkiewicz
