Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2AWWGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:06:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45605 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2AWWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:06:05 -0500
Date: Mon, 23 Jan 2012 22:07:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Roger Leigh <rleigh@codelibre.net>,
        Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120123220720.1b2e9663@pyramind.ukuu.org.uk>
In-Reply-To: <ACD4236E-A309-465F-8789-DA3A5B648313@mit.edu>
References: <20120120140444.GC13157@x2.net.home>
	<20120120154912.GK8797@codelibre.net>
	<CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com>
	<20120120162220.GN8797@codelibre.net>
	<CAPXgP11pvch92n1=mMfDsMLoGZMG8xq0e1juXyUO6mxFR6_GYg@mail.gmail.com>
	<ACD4236E-A309-465F-8789-DA3A5B648313@mit.edu>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 08:55:21 -0500
Theodore Tso <tytso@MIT.EDU> wrote:

> I am extremely dubious about systemd, and would much rather it not be on any system that *I* run (and using UUID's to identify kernel notification is just whacko) , but I have to agree with Kay in that /etc/fstab.d is Just Wrong.   The /etc/fstab file is parsed by many programs, shell scripts, and not just the ones in util-linux.   We should consider it an ABI, and not mess with it.

Pedantically speaking /etc/fstab is not API, getmntent is API.

In practical terms though it would be very 'interesting' to implement
getmentent with an fstab.d, if not down right impossible because the
argument is a FILE *.

So with a good coding hat on - please don't consider fstab API, it's got
a programming interface 8). Otherwise I agree fstab.d is wrong.

Alan
