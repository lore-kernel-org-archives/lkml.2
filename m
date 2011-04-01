Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1DAJO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:14:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1DAJO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:14:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality in separate module
Date: Fri, 1 Apr 2011 11:14:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk@arm.linux.org.uk>, Arend van Spriel <arend@broadcom.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <20110331141424.GD19540@flint.arm.linux.org.uk> <4D94A781.6060904@suse.cz>
In-Reply-To: <4D94A781.6060904@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011114.37940.arnd@arndb.de>
X-Provags-ID: V02:K0:x7+AwlICPDDP2tHdZv/Ppzuvo3XQU1G2NFgYWGnpyZl
 4+OnN+6oaGzVpWm10lYunVlEX80KmABxsZRdffW/Ohn35UTvAS
 Z+DbEAUdcWRNzydkXCoUy0Xay5s6QZG+f0tlTg/VI/CUiXcSPQ
 Fb29jQpAZtrPC/UAKcqaBc+ATyFSkpfrYiQNRvqsqrKT/QhugS
 ri0L9960WuQeUMwGRpXpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Jiri Slaby wrote:
> I don't see why it couldn't like without the packed attribute. (The
> manual says packed attribute for a struct is equivalent to specifying
> packed to each member of that struct. It doesn't say anything about the
> structure alignment itself.)

To give some more background, any variable that is marked packed is
assumed to be potentially unaligned (byte aligned). If a struct
contains only members with byte alignment, it too is byte aligned.

	Arnd
