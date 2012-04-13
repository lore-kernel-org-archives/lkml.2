Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2DMQV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:21:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2DMQVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:21:25 -0400
Date: Fri, 13 Apr 2012 18:21:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franco Catrin <fcatrin@gmail.com>
Subject: Re: [PATCH 0/3] RESEND Aureal special HID driver
In-Reply-To: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
Message-ID: <alpine.LNX.2.00.1204131818130.16373@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz> <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Josenivaldo Benito Junior wrote:

> This patch is a RESEND of hid-aureal patch with Jiri´s suggestions applied.
> It applies over linux-next-20120410 tag of linux-next tree.
> 
> Hid-aureal special HID driver is intend to correct a bogus HID descritor 
> reported by Aureal IR based remote controllers.
> 
> Josenivaldo Benito Junior (3):
>   Aureal Remote Control Device Driver
>   HID: hid-core: Adding hid-aureal special driver
>   HID: hid-aureal: Removing excessive dmesg information

Folded into one patch and applied, thanks.

-- 
Jiri Kosina
SUSE Labs
