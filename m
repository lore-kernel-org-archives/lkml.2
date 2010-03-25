Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0CYUJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:09:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab0CYUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:09:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [RFC 03/15] PM / Hibernate: separate block_io
Date: Thu, 25 Mar 2010 21:12:25 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <4BAA98FC.9040302@crca.org.au> <4BAACC0A.2040009@crca.org.au>
In-Reply-To: <4BAACC0A.2040009@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252112.25204.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Nigel Cunningham wrote:
> Hi again.
> 
> On 25/03/10 09:58, Nigel Cunningham wrote:
> > Hi.
> >
> > On 25/03/10 08:22, Jiri Slaby wrote:
> >> On 03/24/2010 09:30 PM, Pavel Machek wrote:
> >>> On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
> >>>> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
> >>>> +{
> >>>> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE>>   9),
> >>>> +			virt_to_page(addr), bio_chain);
> >>>> +}
> >>>
> >>> sws_ is kind of strange prefix. We were trying to get away from
> >>> "swsuspend" name for quite some time...
> >>
> >> No problem to change the prefix to anything else. Do you (anybody)
> >> suggest anything?
> >>
> >
> > How about some abbreviation of hibernate? "hib"?
> 
> On further reflection, how about "std" (suspend to disk)? I think that's 
> less ugly than the 'hib' suggestion :)

But it also decodes as "standard" if someone is not in the right context. :-)

If the "bio" part of the name is not essential (ie. there's no conflicting name
already), we could call it simply hibernate_read_page().

Rafael
