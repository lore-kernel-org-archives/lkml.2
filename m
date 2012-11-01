Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2KAGy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:54:28 -0400
Received: from mail.agmk.net ([91.192.224.71]:45181 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab2KAGy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:54:27 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, skinsbursky@parallels.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        baggins@pld-linux.org, arekm@pld-linux.org
Subject: Re: [PATCH] lockd: fix races in per-net NSM client handling
Date: Thu, 01 Nov 2012 07:54:21 +0100
Message-ID: <46616972.aF1r9eoRhb@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc3-00030-g8c673cb; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121031182206.GB1542@kroah.com>
References: <1689813.hptKgzjpAu@localhost> <20121031180550.GD30432@elie.Belkin> <20121031182206.GB1542@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 of October 2012 11:22:06 Greg KH wrote:
> On Wed, Oct 31, 2012 at 11:05:51AM -0700, Jonathan Nieder wrote:
> > Hi,
> > 
> > Greg KH wrote:
> > > On Wed, Oct 31, 2012 at 06:27:36PM +0100, Paweł Sikora wrote:
> > 
> > >> the patch metioned in https://lkml.org/lkml/2012/10/24/175 seems to fix
> > >> the 3.6.3 oops (while 3.6.2 works fine) at 16-cores opteron server.
> > >> please queue this path for 3.6.$next.
> > >
> > > Is it in Linus's tree already?  If so, what is the git commit id?
> > 
> > One of
> > 
> >   a4ee8d978e47 LOCKD: fix races in nsm_client_get
> >   e498daa81295 LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero
> > 
> > both of which were included in v3.6.5.
> 
> Ok, Paweł, does 3.6.5 work properly for you?

~12h uptime with full cpu/nfs load and all servers with 3.6.5 seem to work stable.

