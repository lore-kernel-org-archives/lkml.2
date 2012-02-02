Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2BBRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:25:59 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33414 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756878Ab2BBRZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:25:58 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YfzLuUsVM1nZqNQvO_m_6Az04erCC51Ggx2sa5hE2w6nGAy
 l2p7x2qTiONWiy44Gn2BWERABizF7L_gHylsA8rr0cB8G0E0NEazVXsq2Y6Z
 GfFyX8D6DG.93_Yv4dxFPxWwRa5fSp7gkEwkDKk8OLMjN0Ir7f3IbqTOT4N.
 Du5MbwqX37zAKvtNysdrRgCPkuodHqAKKZiI6Ms9D6JB0FX.LUbougI2SQQ6
 4yvUt9niLJU1kOIglF9R3If.Yq55C4a_FMGxFtiz4ufIiNGkP.9SIgi6TuRN
 nzYyEelVnVkHrXEaIlpkf_7eSatNmrBUak9yVpMYO5d7LEIizezani5XUvd_
 TuzIww0R6QczQWDR55hNWcy1YfFFXwcA_yUw4hdtGPAUcXQGRGgZHAF9PcGZ
 H
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Feb 2012 11:25:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
In-Reply-To: <20120202170134.GM2518@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202021124520.6338@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <1328117722.2446.262.camel@twins> <20120201184045.GG2382@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202011404500.2074@router.home> <20120201201336.GI2382@linux.vnet.ibm.com> <4F2A58A1.90800@redhat.com> <20120202153437.GD2518@linux.vnet.ibm.com> <4F2AB66C.2030309@redhat.com> <20120202170134.GM2518@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012, Paul E. McKenney wrote:

> Frederic's work checks to see if there is only one runnable user task
> on a given CPU.  If there is only one, then the scheduling-clock interrupt
> is turned off for that CPU, and RCU is told to ignore it while it is
> executing in user space.  Not sure whether this covers KVM guests.
>
> In any case, this is not yet in mainline.

Sounds great. Is there any plan on when to merge it? Where are the most up
to date patches vs mainstream?

