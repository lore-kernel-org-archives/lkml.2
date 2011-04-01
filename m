Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1DAMH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:07:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1DAMH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:07:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 14:07:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
References: <201103301906.42429.arnd@arndb.de> <201104011322.44729.arnd@arndb.de> <1301658919.27593.72.camel@deskari>
In-Reply-To: <1301658919.27593.72.camel@deskari>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011407.20716.arnd@arndb.de>
X-Provags-ID: V02:K0:WxbHs5rjlBtXGUgX1Q8JjnmhgTOL0abNkaRKfoRkqU0
 5izyCsLH4xEMnQ3uRjoxSRUocGn1g7MlLDKb1Jau6ydNJZ2QMM
 MyWbmmjoGCdqibK7aFS5uHxMNSqwDfh6dJm+2RY9SMrO6l+sY1
 PiDzBxT4p1e4J1FgVqawAvNxiavDyh2cRw92rxvWcfLinvhB8s
 dxf7khtiLyb47KAcLc2lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Tomi Valkeinen wrote:
> Thanks for pointing me to the MCDE stuff. I doesn't seem to be merged,
> though. I need to contact them and see if they're still interested in
> working on the common interface.

I pushed back quite hard on some of the aspects there, which probably
prevented it from going in so far. If the code is as much based on
the OMAP DSS as I think, quite a number of changes are required to
both in order to get them into shape for a decent cross-platform layer,
but there should not be any fundamental issues.

	Arnd
