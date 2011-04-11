Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1DKHAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:00:01 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:45873 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1DKG77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:59:59 -0400
Date: Mon, 11 Apr 2011 08:59:52 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nice values zeroed after hibernate/suspend?
Message-ID: <20110411065952.GA2370@marc.osknowledge.org>
References: <20110409223043.GA23372@marc.osknowledge.org>
 <20110409223228.GB23372@marc.osknowledge.org>
 <20110410150943.GA11073@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110410150943.GA11073@sucs.org>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-rc2-dezzy-11198-g4263a2f-dirty
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sitsofe Wheeler <sitsofe@yahoo.com> [2011-04-10 16:09:44 +0100]:

Thanks, Sitsofe,

I was playing with it again as well and it seemded like the nice values
must somehow have been changed another way. Weird thing. I just
wanted to have it confirmed that it was a PEBKAC error. :)

Regards,
Marc


> On Sun, Apr 10, 2011 at 12:32:28AM +0200, Marc Koschewski wrote:
> > > 
> > > I could report a false positive here when I'm dumb but ... it seems
> > > like the nice values given to a process (-20) are zeroed (=0) when I
> > > resume. Could anyone
> > > please re-test this?
> 
> A suspend to ram/resume still shows a correctly set nice value on
> my 2.6.39-rc2-00120-g94c8a98:
> 
> # nice -n -20 sleep 200 &
> [1] 2460
> # ps -eo "%c %n"  | grep [s]leep
> sleep           -20
> pm-suspend
> <resume>
> # ps -eo "%c %n"  | grep [s]leep
> sleep           -20
> 
> -- 
> Sitsofe | http://sucs.org/~sits/
> 
> 

-- 
Marc Koschewski
