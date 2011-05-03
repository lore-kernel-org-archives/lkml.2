Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1ECRCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:02:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15039 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1ECRCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:02:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 03 May 2011 10:02:03 -0700
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        Allen Martin <AMartin@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Tue, 3 May 2011 10:02:02 -0700
Subject: RE: [v1] Input: tegra-kbc - modify keypress wakeup logic.
Thread-Topic: [v1] Input: tegra-kbc - modify keypress wakeup logic.
Thread-Index: AcwJK+Gi4Ly5A6ZoRI2Fj+epP1zpjQAhsLeQ
Message-ID: <1FC56210173BB445BD77F608D6FB8D032A153969F1@HQMAIL03.nvidia.com>
References: <1304382188-29530-1-git-send-email-riyer@nvidia.com>
 <BANLkTimFKzQk0u3Kwq0MXRXEjUg8xb1JOA@mail.gmail.com>
In-Reply-To: <BANLkTimFKzQk0u3Kwq0MXRXEjUg8xb1JOA@mail.gmail.com>
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

Hello Dmitry

Our hardware design cannot reliably support an arbitrary set of keys waking up the system.

In contrast we can reliably accommodate the scenario where all keys can wake the system.

Our vendors agree to having all keys wake the system up rather than the unreliable solution.

Please let me know if more information is needed.

Thanks and Regards
Rakesh

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Monday, May 02, 2011 5:49 PM
> To: Rakesh Iyer
> Cc: rydberg@euromail.se; Allen Martin; olof@lixom.net; linux-kernel@vger.kernel.org;
> linux-input@vger.kernel.org
> Subject: Re: [v1] Input: tegra-kbc - modify keypress wakeup logic.
> 
> Hi Rakesh,
> 
> On Mon, May 2, 2011 at 5:23 PM,  <riyer@nvidia.com> wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> >
> > Modify wakeup logic so either all keypresses wake the system or none do.
> 
> You need to provide justification for this change (i.e. why the new
> way is better).
> 
> Thanks.
> 
> --
> Dmitry
