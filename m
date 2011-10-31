Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab1JaLAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 07:00:04 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:52824 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520Ab1JaLAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 07:00:03 -0400
Date: Mon, 31 Oct 2011 11:59:59 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Paul Bolle <pebolle@tiscali.nl>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
Message-ID: <20111031105959.GA26898@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein> <20111014133354.GE9412@axis.com> <14215.1318619461@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14215.1318619461@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late answer, I've been in-flight my self.

On Fri, Oct 14, 2011 at 09:11:01PM +0200, Valdis.Kletnieks@vt.edu wrote:
> Shouldn't the patches that upstream those drivers be the ones to add the
> Kconfig glue?  Or is this a case of "in-flight driver" where the submission is
> literally in the middle of getting merged so some parts have landed and some
> haven't yet, and all will be good in the next merge cycle?

You are of course correct that the driver patches should be
ones that add the Kconfigs.

The drivers have been in-flight for quite a while, but without any
push from us, I'll try to give it some love, and at least get it into
a separate tree.

> (Personally, I'm tending towards unless it's going to be in linux-next within
> the next month or so, pull the Kconfig variables out and the driver can re-add
> them when it actually lands)

Ok, let's do it the right way and remove them now, and I can re-add
them in the same tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
