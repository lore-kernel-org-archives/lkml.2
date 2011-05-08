Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1EHKqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 06:46:54 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:37702 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1EHKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 06:46:53 -0400
Subject: Re: [PATCH] selinux: downgrade two printks to KERN_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Date: Sun, 08 May 2011 12:46:38 +0200
In-Reply-To: <1302267622.3937.3.camel@localhost.localdomain>
References: <1302253422.7787.2.camel@t41.thuisdomein>
	 <1302267622.3937.3.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1304851611.7756.9.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Fri, 2011-04-08 at 09:00 -0400, Eric Paris wrote:
> They shouldn't be there at all and it was a big screw up on my part that
> they were left in the committed code.  I already applied but haven't
> sent or pushed a patch to remove these.  Thanks Paul!

0) What's the status of your patch? It is not part of v2.6.39-rc6, is
it?

1) See, I just booted v2.6.39-rc6 and over a thousand of these messages
blew away the messages from the first (about) ten seconds of my first
boot of that kernel:
> $ dmesg | grep filename_trans_read | wc -l
> 1277

As is to be expected, this happened just when I wanted to see how I
apparently misconfigured something by looking at the messages the kernel
prints in those first few seconds ...


Paul

