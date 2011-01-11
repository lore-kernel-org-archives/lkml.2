Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1AKTKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:10:09 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38409 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756270Ab1AKTKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:10:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uH+pk8fTU5xYWMY6Ov2VOIIaRGwpKKlpK3Ykqzs08CjIb1dRZh61WuuW+FyYfU67AxMn3sNI+Q9NUZRnClGMd1Q/br+pDbToTyOa+TACzxgkzWvt6WX3H/zGAroHqr8Y;
Date: Tue, 11 Jan 2011 11:10:04 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joshua Hudson <joshudson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KMS and vgaconsole
Message-ID: <20110111111004.693b8e7c@jbarnes-desktop>
In-Reply-To: <AANLkTik6c5PcC3m5LG8=0g8ecPHNzYWtsM8oy3fv955T@mail.gmail.com>
References: <AANLkTik6c5PcC3m5LG8=0g8ecPHNzYWtsM8oy3fv955T@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 18:41:41 -0800
Joshua Hudson <joshudson@gmail.com> wrote:

> Has anyone tried to implement KMS support for vgaconsole.
> 
> Not everybody wants fbcon (I most certainly do not.)

I don't know of anyone working on it.  It was always a distant TODO
when we were first doing the KMS work, and it's theoretically possible
to have VGA text & graphics modes available as part of KMS, but it
would require some big additions to the graphics drivers.  VGA modes
tend to take a lot more power than high res modes too, since they
activate power hungry legacy hardware that is otherwise disabled.

> Also, having it essentially necessary for some environments
> (co-existing with Xserver-xorg-radion) and unusable with others, such
> as VESA in VM is not a very good situation.

Why not?  Machines typically have supported devices or not; if so they
can use all the good stuff, if not, they can use the compatibility code
(like VESA) exclusively.

-- 
Jesse Barnes, Intel Open Source Technology Center
