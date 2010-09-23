Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0IWVv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:51:57 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51781 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755167Ab0IWVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:51:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=akwtxgQHn2on+OZkBKjM261EAj9iqcyS5sZaKAPax2b2ILgNRvZtfVndR4Xd9rYsb8JCjzpwsMaz+rjrkOl/jr2+DR/OyzRDiDUPpfxlj9aQBMvFFN8GTWn4phMEQYjQ;
Date: Thu, 23 Sep 2010 14:51:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "infernix" <infernix@infernix.net>
Subject: Re: [Bug #18742] PROBLEM: Kernel panic on 2.6.36-rc4 when loading
 intel_ips on Core i3 laptop
Message-ID: <20100923145152.33889673@jbarnes-desktop>
In-Reply-To: <Wn2eLj_6KZG.A.5wG.GE7lMB@chimera>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
	<Wn2eLj_6KZG.A.5wG.GE7lMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 21:08:06 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18742
> Subject		: PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core i3 laptop
> Submitter	: infernix <infernix@infernix.net>
> Date		: 2010-09-15 14:35 (6 days old)
> Message-ID	: <4C90D998.6050103@infernix.net>
> References	: http://marc.info/?l=linux-kernel&m=128456187928496&w=2

Just sent a patch to Matthew and the x86 driver list for this bug.

-- 
Jesse Barnes, Intel Open Source Technology Center
