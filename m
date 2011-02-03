Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1BCVEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:04:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:48224 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BCVEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:04:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,422,1291622400"; 
   d="scan'208";a="654195215"
Message-ID: <4D4B1857.4050504@linux.intel.com>
Date: Thu, 03 Feb 2011 13:04:23 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Daniel Drake <dsd@laptop.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH v2 01/15] x86/e820: remove conditional early
 mapping in parse_e820_ext
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>	<20101230083745.GC11721@angua.secretlab.ca>	<20110104130839.GA21359@www.tglx.de>	<20110114081446.GC21832@angua.secretlab.ca>	<20110114105709.GA7562@www.tglx.de>	<20110114134345.712e2e29@queued.net>	<AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>	<4D4808D2.3080701@linutronix.de>	<20110201103617.2c3aa118@debxo>	<AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>	<20110203104051.12cdfbe5@queued.net>	<4D4B058F.9030208@linux.intel.com>	<20110203120942.1a8fc98c@queued.net>	<4D4B0D18.9010309@linux.intel.com> <20110203123946.701f74a2@queued.net>
In-Reply-To: <20110203123946.701f74a2@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 12:39 PM, Andres Salomon wrote:
> Sorry if I hadn't made that clear, but that's what I was saying.  Go
> ahead with the x86 DT stuff, we'll deal with OLPC breakage later.

Ah, ok, cool.

	-hpa

