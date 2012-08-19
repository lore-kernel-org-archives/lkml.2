Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2HSNpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 09:45:33 -0400
Received: from mail.nonattached.net ([193.160.39.60]:55218 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HSNpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 09:45:30 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
In-Reply-To: <5030E95C.1030908@gmail.com>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish>  <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>  <5030E95C.1030908@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 17:45:15 +0200
Message-ID: <1345391115.2716.44.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 15:25 +0200, Marco Stornelli wrote:
> Ok, I try to do a summary. You are trying to write a new general and 
> minimal fs for mobile storage device, minimal enough to be easy ported 
> on several fs. So at the end you are trying to replace the solution is 
> used today on many platforms (fat32). Without other consideration about 
> "no-feature is a feature", it seems to me really challenging because the 
> project can fail its goal no because there is design problem, bugs and 
> so on but because of limited use. We are talking about interoperability 
> problem, and we really know some companies out there from this point of 
> view :)
You nailed it and you made me feel like Don Quijote.
I'd like to give it a try anyway.

regards,
Dan

-- 
Dan Luedtke
http://www.danrl.de

