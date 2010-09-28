Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab0I1JCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:02:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49860 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0I1JCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LsDS+/xyRTj7bJGxOFzXWtShePWNPI4Q6u0Ylm7g7N+Lvw/QSfHhmOZSZPPmBAU0jD
         1Nd4v4BYRpQq561O4sXQmWmZy3CS4SFY+wjU0VvQV8Bh9d3D+HRbxHiEypp5GJ5na6L6
         fverwCMG0hLOLePCVpwj9UIkg/z5Bai9Ak2oY=
MIME-Version: 1.0
In-Reply-To: <20100928084251.GC3900@legolas.emea.dhcp.ti.com>
References: <1285618704-8985-1-git-send-email-notasas@gmail.com>
	<20100928060554.GF2702@legolas.emea.dhcp.ti.com>
	<AANLkTikZqtXa2YQsDehoWVMRstefUyafsQn2mph7U3CZ@mail.gmail.com>
	<20100928084251.GC3900@legolas.emea.dhcp.ti.com>
Date: Tue, 28 Sep 2010 12:02:48 +0300
Message-ID: <AANLkTin-6BLBHeiyA1edTJVjwVAimmJLVicZj8c_VC_2@mail.gmail.com>
Subject: Re: [PATCH v4] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: balbi@ti.com
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Charger event is SENT by charger driver when it verifies it's attached
> to a wall charger.

Isn't that a job for musb/gadget? Detecting D+/D- being shorted by
charger or something like that? I don't think BCI is able to detect
charger.
