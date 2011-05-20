Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1ETWD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:03:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56185 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753621Ab1ETWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:03:17 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/Ofo5CU5rOYnlW906VCCDH5uZ7clxDOBDLbiGumm
	BpLgsOYvFUV58h
Date: Sat, 21 May 2011 00:03:14 +0200
From: torbenh <torbenh@gmx.de>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110520220314.GA8271@siel.b>
Mail-Followup-To: "D. Jansen" <d.g.jansen@googlemail.com>,
	Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, tytso@mit.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <9534.1305905293@localhost>
 <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:40:49PM +0200, D. Jansen wrote:
> On Fri, May 20, 2011 at 5:28 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Thu, 19 May 2011 15:34:46 +0200, Dennis Jansen said:
> >
> >> Testing:
> >> I've been using this workaround on my netbook for over six months now.
> >> It works as expected for me with all software in a Ubuntu 9.10
> >> environment and saves me at least 0.5 Watt or roughly 10 % battery
> >> time - without destroying my hard disk. I have seen no negative side
> >> effects.
> >
> > How much destructive testing did you do?  In the 6 months, how many times did
> > the system crash (or had the battery pulled out, or whatever) while large
> > amounts of data were still pending after apps thought they were fsync'ed? How
> > much crash testing was done against apps that use fsync for ordering or
> > correctness reasons?
> 
> I don't see the point in verifying the obvious. Of course applications
> that rely on fsync will lose data.
> The real problem comes with ordering correctness, which could actually
> _destroy previous data_ as well.
> In my scenario (office applications, browsing) I have not hit such a problem.

how about making fsync block until the harddisk spins up ?
this would also enable you to detect these apps you wouldnt be using in
laptop mode anyways ?


-- 
torben Hohn
