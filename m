Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0JKOoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:44:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2755 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab0JKOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:44:54 -0400
Subject: Re: get_maintainer
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1286789815.3634.5.camel@jlt3.sipsolutions.net>
References: <1286789815.3634.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 07:44:53 -0700
Message-ID: <1286808293.3416.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 11:36 +0200, Johannes Berg wrote:
> Would it be possible to modify the script to actually look at the
> patches it found and not CC people if the changes to the file in
> question are, say, less than 20% of the overall patch?

Hi Johannes.

Pull this in some test branch and try it out.

git://repo.or.cz/linux-2.6/get_maintainer.git 20100922_gm

If you try this and find it less than adequate,
please tell me why.

Here's the patch series, which is in MM
http://lkml.org/lkml/2010/9/22/464

Here's a couple of recent longish threads about this.
http://lkml.org/lkml/2010/9/10/94
http://lkml.org/lkml/2010/9/25/184



