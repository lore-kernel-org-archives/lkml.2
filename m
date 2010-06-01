Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0FARj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:39:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40614 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0FARjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:39:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
In-Reply-To: Your message of "Tue, 01 Jun 2010 19:52:28 +0300."
             <4C053ACC.5020708@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box>
            <4C053ACC.5020708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275413954_7824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Jun 2010 13:39:14 -0400
Message-ID: <10707.1275413954@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4C0545C3.0062,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275413954_7824P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Jun 2010 19:52:28 +0300, Avi Kivity said:
> On 06/01/2010 07:38 PM, Andi Kleen wrote:
> >>> Your new code would starve again, right?
> > Try it on a NUMA system with unfair memory.

> We are running everything on NUMA (since all modern machines are now 
> NUMA).  At what scale do the issues become observable?

My 6-month-old laptop is NUMA? Comes as a surprise to me, and to the
perfectly-running NUMA=n kernel I'm running.

Or did you mean a less broad phrase than "all modern machines"?


--==_Exmh_1275413954_7824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBUXCcC3lWbTT17ARAktTAKDxJhvoEg58fPeXY/DeyFLB66fKjACguOeh
DxByzoJ8PjkMUrR4ewnyqcc=
=y9Gq
-----END PGP SIGNATURE-----

--==_Exmh_1275413954_7824P--

