Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0LBRIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:08:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55557 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0LBRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:08:15 -0500
Date: Thu, 2 Dec 2010 18:07:56 +0100
From: Borislav Petkov <bp@amd64.org>
To: Florian Mickler <florian@mickler.org>
Cc: Tobias Karnat <tobias.karnat@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202170756.GF27263@aftab>
References: <1291201307.3029.21.camel@Tobias-Karnat>
 <20101201123921.GA15530@a1.tnic>
 <1291209888.12511.11.camel@Tobias-Karnat>
 <20101201143329.GB18074@a1.tnic>
 <1291225614.8646.4.camel@Tobias-Karnat>
 <20101201193508.GA4916@liondog.tnic>
 <1291280613.10626.22.camel@Tobias-Karnat>
 <20101202152106.GA29301@a1.tnic>
 <1291306872.3898.7.camel@Tobias-Karnat>
 <20101202180252.05080815@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202180252.05080815@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 12:02:52PM -0500, Florian Mickler wrote:
> On Thu, 02 Dec 2010 17:21:12 +0100
> Tobias Karnat <tobias.karnat@googlemail.com> wrote:
> 
> > Am Donnerstag, den 02.12.2010, 16:21 +0100 schrieb Borislav Petkov:
> > > Well, thanks for the photos. I don't have an idea what might cause this
> > > workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
> > > change that came in between .35 and .36.1 I can think of being relevant
> > > is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
> > > one out to see whether it fixes the issue.
> > 
> > Yes, reverting this fixed the issue!
> > 
> > But why?
> > 
> > -Tobias
> > 
> > 
> 
> It doesnt work because op_state is set to OP_OFFLINE in edac_mc_del_mc
> before calling edac_mc_workq_teardown. Or am I seeing things?

Good observation Florian, see my other mail I just sent.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
