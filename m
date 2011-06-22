Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab1FVUqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:46:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1FVUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:46:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 14/19] OpenRISC: Module support
Date: Wed, 22 Jun 2011 22:46:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <201106222158.11381.arnd@arndb.de> <1308773139.20122.5268.camel@localhost>
In-Reply-To: <1308773139.20122.5268.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106222246.12593.arnd@arndb.de>
X-Provags-ID: V02:K0:mSXeG+EaNb9bpDRSpOF8b14rnEEUwLuUe2gYdkks4Nf
 FkiyCYDB5gpxJRtyB+uk4XDqLgGukQs1XEyLRlMJ3JaunY8vwH
 PUwqNR1K0rCVURfCTgw8uaJhwriXzqfcyLBLdarzxPRRLTKDtZ
 EwGYEh0t6zfQ7dFZK5OhqL2RhKB1JeFz6BZUqsh7uDmO1g7dkC
 fkMLD+zoOUbgGOjT+GNFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 22:05:39 Jonas Bonn wrote:
> On Wed, 2011-06-22 at 21:58 +0200, Arnd Bergmann wrote:
> > On Wednesday 22 June 2011 21:14:10 Jonas Bonn wrote:
> > > What's an acceptable "comment title"?  Most other arch's seem to put the
> > > filename there... I understand this is undesirable, but what can I put
> > > there instead?  Is "OpenRISC Linux" acceptable, or is nothing at all
> > > preferable?
> > > 
> > > Just want to be clear about what's allowed before I go changing all of
> > > these...
> > 
> > You don't really need anything in the comment, if you want to put something
> > there, I'd recommend a one-line summary of what the file is used for.
> > 
> 
> No license information, copyright, etc?  Nothing?  Would it be
> preferable to delete the comments altogether...?

A lot of people like to have license and copyright information in there,
but it's your choice when you wrote the file.

However, you should never remove someone else's copyright statement when
the code written by that person remain, and you can not change the
license without the author's permission, at least not to an incompatible
one.

	Arnd
