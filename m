Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2E0OIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:08:53 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:49389 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2E0OIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:08:51 -0400
Subject: Re: [PATCH] PM/Hibernate: use rb_entry
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
In-Reply-To: <20120319102712.GA4532@elf.ucw.cz>
References: <1332114885.2632.1.camel@offbook>
	 <20120319102712.GA4532@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sun, 27 May 2012 16:07:41 +0200
Message-ID: <1338127661.4567.0.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 11:27 +0100, Pavel Machek wrote:
> On Mon 2012-03-19 00:54:45, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > Since the software suspend extents are organized in an rbtree, use rb_entry
> > instead of container_of, as it is semantically more appropriate in order to
> > get a node as it is iterated.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> 
> ACK.

ping about this...

thanks.

