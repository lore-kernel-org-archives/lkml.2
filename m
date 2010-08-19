Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0HSHlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 03:41:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab0HSHk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 03:40:58 -0400
Date: Thu, 19 Aug 2010 09:40:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Gabriel Craciunescu <osnix0@googlemail.com>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, trapdoor6@gmail.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
In-Reply-To: <AANLkTikooEGbmLT-UVZ3wb1jAjocT1eO06tZkg+kQefV@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1008190939460.1019@pobox.suse.cz>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com> <201008180325.17816.rjw@sisk.pl> <AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com> <alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz> <AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
 <alpine.LNX.2.00.1008181045110.1019@pobox.suse.cz> <AANLkTikPC1CGjNcP2ARf8SJw3HTEBOcdgGnDjx87DERX@mail.gmail.com> <AANLkTimSkniqYYWAD29VK6Rt45b_5A84fuK0m0q9EznC@mail.gmail.com> <AANLkTikooEGbmLT-UVZ3wb1jAjocT1eO06tZkg+kQefV@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Gabriel Craciunescu wrote:

> > > Andrea, Gabriel
> > > Would you please check if Jiri's patch solves the problem on your end
> > > as well? Just to make 100% sure we can close related bugzilla call.
> >
> > Well, I made the test, with ~10 cycle hibernation/resume.
> > Everything seems goes right.
> >
> 
> Does work fine here also ..

Thanks everyone for confirming. The fix is now in Linus' tree and thus 
will be in -rc2.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
