Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab0HLNRv convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Thu, 12 Aug 2010 09:17:51 -0400
Received: from smtp-out-205.synserver.de ([212.40.180.205]:1059 "HELO
	smtp-out-205.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753558Ab0HLNRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:17:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 14549
Date: Thu, 12 Aug 2010 15:17:45 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Ott <alan@signal11.us>, Heinz Diehl <htd@fritha.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100812131745.GA1618@arch.tripp.de>
References: <20100812091659.GA1591@arch.tripp.de>
 <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
 <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de>
 <20100812115657.GA1611@arch.tripp.de>
 <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
 <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
 <20100812130411.GA1626@arch.tripp.de>
 <4C63F285.8070801@signal11.us>
 <alpine.LNX.2.00.1008121510180.2702@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1008121510180.2702@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o7CDJ22P011082

On Thu, Aug 12, 2010 at 03:11:39PM +0200, Jiri Kosina wrote:
> On Thu, 12 Aug 2010, Alan Ott wrote:
> > > > >        
> > > > Could please those of you, who are able to reproduce the problem, verify
> > > > whether the patch below (completely untested) makes everything behave
> > > > again? Thanks.
> > > >      
> > > Yes, everything behaves again. Thanks Jiri.
> > >    
> > 
> > Seconded. Works good. Thanks for your support Jiri.
> 
> Thanks for your testing. I still need to think a little bit more about 
> whether this is indeed an appropriate fix or there might be still some 
> problem.

No need to hurry. Rc1 isn't even out yet.

> Once I will be applying this, I will put
> 
> 	Reported-and-tested-by: 
> 
> tag for both of you Alan and Markus, is that fine?

It's also fine with me.

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
