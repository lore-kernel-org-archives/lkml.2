Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2HTRhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:37:04 -0400
Received: from mail.nonattached.net ([193.160.39.60]:59484 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2HTRhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:37:01 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <50310512.5010108@gmail.com>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>
	 <20120819120254.GA2369@pompeji.miese-zwerge.org>
	 <1345390432.2716.34.camel@tunafish>
	 <20120819142732.GB23464@ZenIV.linux.org.uk>
	 <1345395217.2716.58.camel@tunafish>  <50310512.5010108@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Aug 2012 19:36:56 +0200
Message-ID: <1345484216.18266.10.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 16:12 +0100, Al Viro wrote:
> Conversions *in* *place* are bad. [+explanation]
I think I got it now.

On Sun, 2012-08-19 at 17:24 +0200, Marco Stornelli wrote:
> [vmtruncate, dio_wait, locking, d_delete]
Noted!

Thanks both of you!

Regards
Dan

-- 
Dan Luedtke
http://www.danrl.de

