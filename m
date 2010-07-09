Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0GIPid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:38:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58227 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab0GIPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=RfsCfLjXjxtBhIP0cpoU393Fgoo4i/3hjvQKPdRtmJFgW/U7+Ykt1764fQHqqDhJwh
         9hZRf9sbuaTyAway8Fk5Y57uzYFU2/whzyinZXwrVwnTSVTrUH6n+o+P9S2kYCL7uv/Z
         gQMaseBKI+dpAdd1W1WrZJmywte2v9TOxoVA0=
MIME-Version: 1.0
In-Reply-To: <ed2d69ca06335b2bad6f03a94f78b06be5e4061a.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de> <ed2d69ca06335b2bad6f03a94f78b06be5e4061a.1278682303.git.siccegge@cs.fau.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 9 Jul 2010 11:38:11 -0400
Message-ID: <AANLkTimAZlbWsX8y462PAeqngDl6pt0ui7F44aIjXGas@mail.gmail.com>
Subject: Re: [PATCH 10/11] Removing dead SERIAL_BFIN_SPORT_CTSRTS
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
> SERIAL_BFIN_SPORT_CTSRTS doesn't exist in Kconfig, therefore removing
> all references for it from the source code.

NAK: it is defied & used locally
-mike
