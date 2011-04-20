Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1DTOSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:18:47 -0400
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:56286 "EHLO
	mailchk-m05.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753110Ab1DTOSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:18:45 -0400
Date: Wed, 20 Apr 2011 10:18:23 -0400
From: Kyle Spaans <kspaans@uwaterloo.ca>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: 2.6.39-rc1 nouveau(?) regression (bisected)
Message-ID: <20110420141823.GA8166@taurine.csclub.uwaterloo.ca>
References: <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan>
 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan>
 <20110418200204.GA2522@joi.lan>
 <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
 <20110419214747.GA2965@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419214747.GA2965@joi.lan>
X-PGP-Key: http://csclub.uwaterloo.ca/~kspaans/kspaans-pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-UUID: d08bcc71-50ed-45d0-a452-87d9cf9f3893
X-Miltered: at mailchk-m05 with ID 4DAEEB2F.002 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (mailchk-m05.uwaterloo.ca [129.97.128.141]); Wed, 20 Apr 2011 10:18:28 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:47:47PM +0200, Marcin Slusarz wrote:
> Thanks. It helped a bit.
> I'll send two patches in response to this message, one of which fixes this bug.

Those patches fixed my system. Thanks!
