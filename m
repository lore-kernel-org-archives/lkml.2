Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GTMKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:10:12 -0400
Received: from mail.elutions.com ([64.31.159.3]:34206 "EHLO mail.elutions.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1GTMKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:10:10 -0400
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jul 2011 08:10:10 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression in handling of unsafe UBI shutdown
Date: Wed, 20 Jul 2011 07:45:04 -0400
Message-ID: <F87D23B7E1F84E4AB52E4FA4A55F85DC026DADA5@tpamail.elutions.com>
In-Reply-To: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in handling of unsafe UBI shutdown
Thread-Index: AcxGG8lVZX8dGirvQ1Gn3q+MVe9rUwAtV/Qg
From: "Mike Hench" <mhench@elutions.com>
To: "Daniel Mack" <zonque@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Adrian Hunter" <adrian.hunter@nokia.com>,
        "Sven Neumann" <s.neumann@raumfeld.com>,
        "Artem Bityutskiy" <dedekind1@gmail.com>
X-Mlf-Version: 7.2.4.3925
X-Mlf-UniqueId: o201107201024130004353
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> UBIFS: recovery needed
> Error reading superblock on volume 'ubi:RootFS'!
> UBIFS not mounted, use ubifs mount to mount volume first!
> Wrong Image Format for bootm command
> ERROR: can't get kernel image!


Be nice to know what error.
FWIW:
a) I do not see this. I have very limited experience with 3.0-rc7 though
so maybe I should not say anything :-)

b) sometimes UBIFS decides to do recovery in u-boot, sometimes not.
it seems to depend on the type of content in the journal.
Lots of deleted files seem to trigger u-boot to perform a recovery for
instance.
I was running out of memory In u-boot while replaying the journal
at one point with an older kernel. This produced the same top level
error.
I run 12 megs now, with a 2gigabyte flash. I think that is overkill.

Work with u-boot with the 'bad' flash.
There is debugging in there, but I forget how to turn it on.

Mike Hench

