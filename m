Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1FOSwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:52:23 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58957 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753731Ab1FOSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:52:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QPXSk+sCtQgJfYeSDkh0hX4mqEH0y2NS4k/W21OGibI1g9y0AGkV3/rkyUEQ4arI/yyMaoOEcXQwxgcT2Ny+d6Fh1xmqxndGzND1RlmryoWLQ93oD7bYxHwnhZtmr27P;
Date: Wed, 15 Jun 2011 11:52:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dennis Jansen" <dennis.jansen@web.de>
Subject: Re: [Bug #36392] 2.6.39, 3.0-rc2 Intel DRI Regression: Black Screen
 after trying to play video
Message-ID: <20110615115201.0264039b@jbarnes-desktop>
In-Reply-To: <kTLfM29CaqB.A.tBF.6zS9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
	<kTLfM29CaqB.A.tBF.6zS9NB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 23:12:11 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36392
> Subject		: 2.6.39, 3.0-rc2 Intel DRI Regression: Black Screen after trying to play video
> Submitter	: Dennis Jansen <dennis.jansen@web.de>
> Date		: 2011-06-01 04:41 (12 days old)

Did you ever bisect this issue?

-- 
Jesse Barnes, Intel Open Source Technology Center
