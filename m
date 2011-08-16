Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1HPO50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:57:26 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41011 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1HPO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:57:25 -0400
Date: Tue, 16 Aug 2011 16:57:04 +0200
From: Florian Mickler <florian@mickler.org>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: 3.1-rc1-git9: Reported regressions 2.6.39 -> 3.0
Message-ID: <20110816165704.59fda93d@schatten.dmk.lab>
In-Reply-To: <4E498E09.1000208@fastmail.fm>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<4E498E09.1000208@fastmail.fm>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 23:22:17 +0200
Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> On 08/14/2011 09:02 PM, Rafael J. Wysocki wrote:
> 
> > Please let the tracking team know if there are any Bugzilla entries that
> > should be added to the list in there.
> > 
> 
> Could you please add
> 
> Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=41212
> Subject         : ipoib causes kernel panic (NULL pointer dereference)
> Submitter       : Bernd Schubert <bernd.schubert@fastmail.fm>
> Date            : 2011-08-15 15:40
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=68942
> 
> 
> Thanks,
> Bernd

Done. Please submit the patch to netdev mailinglist for review. 

Regards,
Flo
