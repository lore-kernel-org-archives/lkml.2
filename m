Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0GIPjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:39:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63242 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0GIPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=v4upvkoaNhYSxqB0lfcGM5aAA+7u9+Xdv8l8EVcuQ2aeaxvFsCPRukVbef7qoUwp4a
         3l2UrxGVbfcvM2k/sJavqyh2btgOYy5KeMTrwsvdV7M3N1N4TvbmVzn1u/lxeDw4Oflm
         JcPbYyNc8cn3YZ+ISaXBqtCr+6QYaYuQFagyw=
MIME-Version: 1.0
In-Reply-To: <86b706944a84c030fbd88d005e8d6365cb7921da.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de> <86b706944a84c030fbd88d005e8d6365cb7921da.1278682303.git.siccegge@cs.fau.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 9 Jul 2010 11:39:09 -0400
Message-ID: <AANLkTimBPFupVlodhd1YikHRDbhsn9jl_ZHY_wgZZG92@mail.gmail.com>
Subject: Re: [PATCH 11/11] Removing dead SERIAL_BFIN_SPORT_CONSOLE
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
       Sonic Zhang <sonic.zhang@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 09:50, Christoph Egger wrote:
> SERIAL_BFIN_SPORT_CONSOLE doesn't exist in Kconfig, therefore removing
> all references for it from the source code.

NAK

your source is outdated then:
./Kconfig:config SERIAL_BFIN_SPORT_CONSOLE
-mike
