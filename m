Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2GPNco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:32:44 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:24968 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751484Ab2GPNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:32:40 -0400
Message-ID: <1342445557.2523.8.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: resurrecting tcphealth
From: Ben Hutchings <bhutchings@solarflare.com>
To: Piotr Sawuk <a9702387@unet.univie.ac.at>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 14:32:37 +0100
In-Reply-To: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at>
References: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 09:56 +0200, Piotr Sawuk wrote:
> On Sa, 14.07.2012, 03:31, valdis.kletnieks@vt.edu wrote:
> > On Fri, 13 Jul 2012 16:55:44 -0700, Stephen Hemminger said:
> >
> >> >+			/* Course retransmit inefficiency- this packet has been received
> >> twice. */
> >> >+			tp->dup_pkts_recv++;
> >> I don't understand that comment, could you use a better sentence please?
> >
> > I think what was intended was:
> >
> > /* Curse you, retransmit inefficiency! This packet has been received at
> least twice */
> >
> 
> LOL, no. I think "course retransmit" is short for "course-grained timeout
> caused retransmit" but I can't be sure since I'm not the author of these
> lines. I'll replace that comment with the non-shorthand version though.
> however, I think the real comment here should be:
[...]

The word you are looking for is 'coarse' not 'course' (they are
generally pronounced the same, to confuse you).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

