Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1FOSqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:46:21 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:56726 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752248Ab1FOSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:46:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q/8Wg4QVFT9XJEe0MapQhZTGaH8RUqY+PsB7YfnHxx/42tPf61vTzireAVVQoUC2G/bCATzlSO/MVgZTtwxflG5pmE5kmlhdDjbAj7ljpIfNrrumT6dOA3D0Pm4N+VXK;
Date: Wed, 15 Jun 2011 11:46:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #34002] [REGRESSION] [2.6.39-rc3] Wrong resolution in
 framebuffer and X Window
Message-ID: <20110615114614.054df25f@jbarnes-desktop>
In-Reply-To: <kTLfM29CaqB.A.P3F.a1S9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
	<kTLfM29CaqB.A.P3F.a1S9NB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 23:12:08 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34002
> Subject		: [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2011-04-17 16:04 (57 days old)
> Message-ID	: <201104171804.04664.maciej.rutecki@gmail.com>
> References	: http://marc.info/?l=linux-fbdev&m=130305625114863&w=2

Did you ever bisect this issue? As Chris says it sounds like an EDID
problem; we detect the outputs and attach some modes, but they sound
like the wrong ones for your config.  Maybe we broke EDID fetching for
your config?

-- 
Jesse Barnes, Intel Open Source Technology Center
