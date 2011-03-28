Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1C1LbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:31:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40220 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1C1LbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:31:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #28842] 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
	<40UNry85rJN.A.BAF.6o5jNB@chimera>
Date: Mon, 28 Mar 2011 04:30:55 -0700
In-Reply-To: <40UNry85rJN.A.BAF.6o5jNB@chimera> (Rafael J. Wysocki's message
	of "Sun, 27 Mar 2011 22:27:35 +0200 (CEST)")
Message-ID: <m1zkofzdlc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/TGesHm9wgAE2UO/QZzDyVfUBQbaib/Ng=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
> Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
> Submitter	: Eric W. Biederman <ebiederm@xmission.com>
> Date		: 2011-02-08 9:41 (48 days old)
> Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
> References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2

As of 2.6.38 I no longer have problems.

Eric

