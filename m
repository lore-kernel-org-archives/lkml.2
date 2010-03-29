Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0C2Rp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:45:26 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58873 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0C2RpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OcqdQK6S1JxCFZeWPl9ys2BM/aRBXug+lY37wE/STa08Z5TEXHwfI1N6OHeN/GSPMx
         sQEnbpxM8dr9rnmIzK2zLmn8VjauxHpkvLhOTSkTJajYTS4/DeaQ8JJDe3bG4ctqfwbQ
         /fsSO7bJMC6B/tGNApgte+LSpZS4SCn/JHxyw=
Subject: Re: Network performance - iperf
From: Eric Dumazet <eric.dumazet@gmail.com>
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
In-Reply-To: <4BB0C6E1.2090606@petalogix.com>
References: <4BB09021.6020202@petalogix.com>
	 <1269864994.2164.21.camel@edumazet-laptop> <4BB0BF28.5090505@petalogix.com>
	 <4BB0C6E1.2090606@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 19:45:17 +0200
Message-ID: <1269884717.1958.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 mars 2010 à 17:27 +0200, Michal Simek a écrit :
> Michal Simek wrote:
> > Eric Dumazet wrote:
> >> Le lundi 29 mars 2010 à 13:33 +0200, Michal Simek a écrit :
> >>
> >>> Do you have any idea howto improve TCP/UDP performance in general?
> >>> Or tests which can point me on weak places.
> >>
> >> Could you post "netstat -s" on your receiver, after fresh boot and your
> >> iperf session, for 32 MB and 256 MB ram case ?
> >>
> > 
> > I am not sure if is helpful but look below.
> > 
> Sorry I forget to c&p that second part. :-(
> 

Sorry, your netstat is not up2date.

If you cannot correct it to last version
[ net-tools 1.60 , netstat 1.42 ], please send

cat /proc/net/snmp
cat /proc/net/netstat


