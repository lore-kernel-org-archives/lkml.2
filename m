Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2CEHbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:31:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2CEHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:31:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of udknight@gmail.com designates 10.50.168.99 as permitted sender) smtp.mail=udknight@gmail.com; dkim=pass header.i=udknight@gmail.com
Date: Mon, 5 Mar 2012 15:25:51 +0800
From: Wang YanQing <udknight@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120305072551.GA8120@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	spock@gentoo.org
References: <20120302004850.GA4139@udknight>
 <20120305005250.GA17071@udknight>
 <4F54669E.6080009@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54669E.6080009@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 07:09:18AM +0000, Florian Tobias Schandinat wrote:
> Hi,
> 
> On 03/05/2012 12:52 AM, Wang YanQing wrote:
> > On Fri, Mar 02, 2012 at 08:48:50AM +0800, Wang YanQing wrote:
> >>
> >> Ok! I think I have learned to make thing simple and send to the right people:)
> 
> That's right.
> 
> >> This patch try to fix the oops below that catched in my machine
> 
> This sounds like you didn't test it. I assume you did? So just write
> "This patch fixes the oops below"
Yes, I had tested it on three machines.
I think I have got a good lesson, thanks so much!



