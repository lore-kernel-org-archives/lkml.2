Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0G3OTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:19:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:59502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0G3OTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:19:30 -0400
Message-ID: <4C52DF50.80009@kernel.org>
Date: Fri, 30 Jul 2010 16:18:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@lists.osdl.org, stephan.diestelhorst@amd.com
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007100850.36889.stephan.diestelhorst@gmail.com> <4C384580.2080507@kernel.org> <201007282350.09676.rjw@sisk.pl>
In-Reply-To: <201007282350.09676.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 14:18:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

Sorry about the delay.  There was a tiny crisis here and the whole
link pm seems to need a lot more work than I originally expected.  I'm
working on it now.  I'll probably have something for you to test in a
few days.

Thanks.

-- 
tejun
