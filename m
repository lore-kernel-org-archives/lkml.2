Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0DQUkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 16:40:14 -0400
Received: from tex.lwn.net ([70.33.254.29]:35941 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab0DQUkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 16:40:13 -0400
Date: Sat, 17 Apr 2010 14:40:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 1/7] viafb: package often used basic io functions
Message-ID: <20100417144008.2bdd49f9@bike.lwn.net>
In-Reply-To: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Apr 2010 19:44:51 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> This patch puts redesigned versions of the basic io functions that
> are used overall the driver in an extra header.

I don't object to the basic idea of these patches, but...as I'm sure
you can imagine, this stuff will conflict hard with the work I'm trying
to prepare for submission.  I, too, have had to go in to those
functions and do things like add locking.  Is there any chance you
could hold off for just a *little* bit while I get things together?  

As I said before, I was traveling this last week.  Now I'm home and can
get back to this...

Thanks,

jon
