Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab0DHXj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:39:28 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59853 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933759Ab0DHXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:39:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bqaZLBZ+kMw8V2Hcu2I4jfVqXj0xNrwDNE4t0WktIDw1Jl3XRSvCiyfByZjFn4hz4IgGytx01tF9jUac25h6UrmKTAp5GVMdLoRfjULrLAsn8JutvGNOO8sOMBKEpX9c;
Date: Thu, 8 Apr 2010 16:39:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Adam Jackson" <ajax@redhat.com>, "Eric Anholt" <eric@anholt.net>,
       "Santi" <santi@agolina.net>, "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: [Bug #14792] Misdetection of the TV output
Message-ID: <20100408163916.67d054ef@virtuousgeek.org>
In-Reply-To: <onZ81XwyNTD.A.MXE.uJmvLB@chimera>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
	<onZ81XwyNTD.A.MXE.uJmvLB@chimera>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Apr 2010 00:54:29 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
> Subject		: Misdetection of the TV output
> Submitter	: Santi <santi@agolina.net>
> Date		: 2009-12-12 13:28 (118 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/27dfaf4f5825a119305db1bc63bef30ed400e376
> Handled-By	: Zhao Yakui <yakui.zhao@intel.com>

Looks like Yakui just pushed the fix for this one, so hopefully we'll
be able to close it soon.

-- 
Jesse Barnes, Intel Open Source Technology Center
