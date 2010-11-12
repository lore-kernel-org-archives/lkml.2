Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0KLTQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:16:34 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:38009 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab0KLTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:16:31 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 8FE3F107FE3
Subject: Re: [PATCH] HID: roccat: Add support for Roccat Kone[+]
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011051400250.15851@pobox.suse.cz>
References: <1287943025.2623.16.camel@neuromancer>
	 <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz>
	 <1288978962.2585.15.camel@neuromancer>
	 <alpine.LNX.2.00.1011051400250.15851@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 20:16:23 +0100
Message-ID: <1289589383.2629.96.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 05.11.2010, 14:01 -0400 schrieb Jiri Kosina:
> On Fri, 5 Nov 2010, Stefan Achatz wrote:
> 
> > > > This patch adds support for Roccat Kone[+] gaming mouse. Kone[+] is an enhanced version
> > > > of the old Kone with more memory for macros, a better sensor and more functionality.
> > > > This driver is conceptual similar to the existing Kone and Pyra drivers.
> > > > Userland tools can soon be found at http://sourceforge.net/projects/roccat
> > > 
> > > Seems like there is a lot of duplicate code with Roccat Kone.
> > > Is there any reason this couldn't be merged with the Roccat Kone 
> > > counterparts?
> > 
> > In fact the Kone[+] seems to be nearer to the Pyra than the old Kone.
> > Looks like the manufacturer changed the firmware programmer between some
> > devices. I wanted to wait until I see more devices of this manufacturer
> > if some kind of genealogy might be visible and remove code duplication
> > based on that.
> 
> It would be really nice, otherwise this gets into unmaintainable mess very 
> quickly.

Just to clarify my words if someones waiting for a patch: That was meant
in a longer term. I'm beginning a new device after I finish Kone[+]
userland tools. That would be at the earliest in january. What I wanted
to say was to please apply these patches in this state, the code
duplication gets handled with the next device.
Thanks,
Stefan

