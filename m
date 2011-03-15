Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab1COLqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:46:44 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:38645 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab1COLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:46:41 -0400
Message-ID: <24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110315112724.6729.qmail@stuge.se>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
    <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
    <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
    <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
    <5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
    <20110315112724.6729.qmail@stuge.se>
Date: Tue, 15 Mar 2011 12:46:29 +0100 (CET)
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: "Indan Zupancic" <indan@nul.nu>
To: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, "Matthew Garrett" <mjg@redhat.com>,
        "Len Brown" <lenb@kernel.org>, "Alan Cox" <alan@linux.intel.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 964c6a2bc69af72888bec91466701c23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, March 15, 2011 12:27, Peter Stuge wrote:
> coreboot has existed for about eleven years and some 250 mainboards of
> varying shapes and sizes (from laptop to server) are supported, but it's

I've been wanting to get rid of BIOSes and use Coreboot for ages,
but the amount of hassle needed to get it working for my hardware
and the lack of features (suspend), as well the chance of bricking
the system always put me off.

> only just recently that things are really taking off, with the code
> release from AMD to initialize their most recent Fusion platform.

They don't give their Linux devs any Fusion hardware, nor do they
open the UVD spec, but at least they release info like this.

Greetings,

Indan


