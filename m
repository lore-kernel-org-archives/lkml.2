Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2GEVGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:06:33 -0400
Received: from seven.medozas.de ([5.9.24.206]:36751 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2GEVGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:06:24 -0400
Date: Thu, 5 Jul 2012 23:06:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
In-Reply-To: <20120629231236.GA28593@mail.collabora.co.uk>
Message-ID: <alpine.LNX.2.01.1207052242450.2202@frira.zrqbmnf.qr>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <20120629.153656.1141845894730637434.davem@davemloft.net> <20120629231236.GA28593@mail.collabora.co.uk>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-06-30 01:12, Vincent Sanders wrote:
>
>Firstly it is intended is an interprocess mechanism and not to rely on
>a configured IP system, indeed one of its primary usages is to
>provide mechanism for various tools to set up IP networking.

Using IP as a localhost IPC is not uncommon (independent of
software preferring AF_UNIX, if so available). Distro boot
scripts have been running `ip addr add ::1/128 dev lo`
all these years along.

And now we suddently need a DBUS program just to configure
IP-based localhost IPC? I can see the flaw in that.
