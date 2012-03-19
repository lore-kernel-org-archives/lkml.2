Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2CSK1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:27:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51839 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2CSK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:27:16 -0400
Date: Mon, 19 Mar 2012 11:27:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Davidlohr Bueso <dave@gnu.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM/Hibernate: use rb_entry
Message-ID: <20120319102712.GA4532@elf.ucw.cz>
References: <1332114885.2632.1.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332114885.2632.1.camel@offbook>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2012-03-19 00:54:45, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Since the software suspend extents are organized in an rbtree, use rb_entry
> instead of container_of, as it is semantically more appropriate in order to
> get a node as it is iterated.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
