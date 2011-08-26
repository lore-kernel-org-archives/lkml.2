Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1HZIzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:55:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40007 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1HZIzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
Date: Fri, 26 Aug 2011 10:55:17 +0200
Message-ID: <CACna6ryWtZG9obyj0w=d5jrF-y1pYNmanhkze2F429kHCLCi=A@mail.gmail.com>
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Henry Ptasinski <henryp@broadcom.com>, linux-kernel@vger.kernel.org,
        Brett Rudley <brudley@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        devel@linuxdriverproject.org, Greg KH <gregkh@suse.de>,
        Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/25 Joe Perches <joe@perches.com>:
> Convert multiple BRCMF_<debug_level> macros to a single
> brcmf_dbg(level, fmt, ...) macro.

I'm not sure if that "_dbg" suffix is a really good choice. You use
"_dbg" for all the kinds of messages, while "DEBUG" is already one
kind of messages. We have also other types like EMERG, ALERT, CRIT,
ERR, WARNING, NOTICE, INFO and DEBUG.

You choice makes it messy according to me.

Wouldn't something like brcmf_print be much better choice?

I really don't like such a mixing dbg&DEBUG, dbd&ERR, etc.

-- 
Rafał
