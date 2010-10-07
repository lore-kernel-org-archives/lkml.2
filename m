Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0JGVpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:45:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab0JGVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:45:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] ACPI: Read TSC upon resume
Date: Thu, 7 Oct 2010 23:44:21 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Sameer Nanda <snanda@chromium.org>, lenb@kernel.org,
        stefan.bader@canonical.com, brad.figg@canonical.com, apw@canonical.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286406919-6236-1-git-send-email-snanda@chromium.org> <AANLkTik=imw5XRpXSkboyB6txXio6Y65bLV+EdfvRXg3@mail.gmail.com> <20101007181536.GA24811@suse.de>
In-Reply-To: <20101007181536.GA24811@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010072344.22166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 07, 2010, Greg KH wrote:
> On Thu, Oct 07, 2010 at 11:05:21AM -0700, Sameer Nanda wrote:
> > On Thu, Oct 7, 2010 at 10:46 AM, Greg KH <gregkh@suse.de> wrote:
> > > On Thu, Oct 07, 2010 at 10:43:34AM -0700, Sameer Nanda wrote:
> > >> On Wed, Oct 6, 2010 at 7:19 PM, Greg KH <gregkh@suse.de> wrote:
> > >> > And are you always going to be printing this out?  Why do we want to
> > >> > know this every time?
> > >> >
> > >>
> > >> Yes, every time.  This helps track variance in BIOS resume times within a
> > >> single boot.
> > >
> > > Is that really something that users can do something about?
> > 
> > Aside from complaining to the BIOS vendors, no :)
> 
> Then I would not recommend adding this patch, as it is irrelevant for
> 99.9999% of all Linux users.

It may be somewhat useful, but the rdtscll() call seems to be x86-specific, in
which case it shouldn't be used at this place.

Thanks,
Rafael
