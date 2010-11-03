Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab0KCTkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:40:33 -0400
Received: from mail.perches.com ([173.55.12.10]:3956 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0KCTkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:40:31 -0400
Subject: Re: [PATCH v1 00/12] netoops support
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Mike Waychison <mikew@google.com>,
        simon.kagstrom@netinsight.net, davem@davemloft.net, adurbin@google.com,
        akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20101103115020.ad8a4ecc.randy.dunlap@oracle.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
	 <20101103023422.GB5782@kroah.com>
	 <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
	 <20101103181634.GF7441@kroah.com>
	 <20101103115020.ad8a4ecc.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 12:40:29 -0700
Message-ID: <1288813229.10236.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 11:50 -0700, Randy Dunlap wrote:
> On Wed, 3 Nov 2010 11:16:34 -0700 Greg KH wrote:
> > On Tue, Nov 02, 2010 at 08:37:42PM -0700, Mike Waychison wrote:
> > > On Tue, Nov 2, 2010 at 7:34 PM, Greg KH <greg@kroah.com> wrote:
> > As for the user/kernel interface, perhaps exporting the data in a text
> > format that is "tagged" would be best?  Then the whole world can parse
> > it easily.
> I have been (occasionally) looking at critical kernel messages.
> IMO we really need an easy way to find them.
> They can begin with any of these strings (and others can be added
> too easily):
> BUG|panic|MCE|NMI|error:|Oops|Bad|Fatal|Unrecoverable|Unhandled|Weird
> We need a simple (single?) tagging method to identify any/all of these,
> /methinks.

Simply marking these messages KERN_CRIT or higher would seem to work.


