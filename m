Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab2JCPWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:22:21 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38586 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2JCPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <1349276601-8371-26-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-26-git-send-email-florian@openwrt.org>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Wed, 3 Oct 2012 17:21:37 +0200
Message-ID: <CAOLZvyHyQGZ=Rs1=k07Saq16aZcntUe8N0Fc5iMoeOTeMpjcSw@mail.gmail.com>
Subject: Re: [PATCH 24/25] MIPS: Alchemy: use the OHCI platform driver
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 5:03 PM, Florian Fainelli <florian@openwrt.org> wrote:
> This also greatly simplifies the power_{on,off} callbacks and make them
> work on platform device id instead of checking the OHCI controller base
> address like what was done in ohci-au1xxx.c.

That was by design -- the base address is far more reliable in identifying the
correct controller instance than the platform device id.   There are systems
in the field which don't use the alchemy/common/platform.c file at all.


Manuel
