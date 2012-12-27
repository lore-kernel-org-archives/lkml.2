Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2L0Nlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:41:36 -0500
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:44787 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0Nle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:41:34 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 27 Dec 2012 08:28:22 -0500
Subject: RE: [PATCH 0/6 v8] cpufreq: add support for Calxeda ECX-1000
 (highbank)
Thread-Topic: [PATCH 0/6 v8] cpufreq: add support for Calxeda ECX-1000
 (highbank)
Thread-Index: Ac3kMyRna9NDQaO4Svq45co2n9X64gAAuaOV
Message-ID: <21672683C5A3814BB4DB938EBE482DE435D97660AB@IAD2MBX09.mex02.mlsrvr.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com>,<2705062.NIaFfcLb3a@vostro.rjw.lan>
In-Reply-To: <2705062.NIaFfcLb3a@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I had addressed all the issues with the v9 version. The only comments I got on it was Mike's reviewed-by and I didn't think that warranted a resend.

If you do want me to send it again, do you want it  updated to current top-of-tree? That may take a bit, since there's an unrelated bug that's preventing my test box from booting.

--Mark Langsdorf
Calxeda, Inc.


________________________________________
From: Rafael J. Wysocki [rjw@sisk.pl]
Sent: Thursday, December 27, 2012 7:12 AM
To: Mark Langsdorf
Cc: linux-kernel@vger.kernel.org; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6 v8] cpufreq: add support for Calxeda ECX-1000 (highbank)

On Wednesday, December 05, 2012 10:48:35 AM Mark Langsdorf wrote:
> This patch series adds cpufreq support for the Calxeda
> ECX-1000 (highbank) SoCs. The EnergyCore Management Engine (ECME) on
> the ECX-1000 manages the voltage for the part and communications with
> Linux through a pl320 mailbox. clk notifications are used to control
> when to send messages to the ECME.

If you want me to handle this, can you please resend the whole patchset (with
all of the comments addressed, if possible)?

Rafael


--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
