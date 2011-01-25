Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab1AYBcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:32:19 -0500
Received: from mail4.comsite.net ([205.238.176.238]:10627 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AYBcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:32:19 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: <linux-kernel@vger.kernel.org>, Tapio Vihuri <tapio.vihuri@nokia.com>
Subject: Re: checkpatch file name stripped mode
Message-Id: <file-stripping@mdm.bga.com>
In-Reply-To: <1295440968.2276.46.camel@dell>
References: <1295440968.2276.46.camel@dell>
Date: Mon, 24 Jan 2011 19:32:18 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jan 19 2011 about 07:42:55 EST, Tapio Vihuri wrote:
> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig
> WARNING: please write a paragraph that describes the config symbol fully
> #430: FILE: input/misc/Kconfig:430:

I notice that the first directory of the file name was stripped ...
seems like that should not be the default for file mode?

milton
