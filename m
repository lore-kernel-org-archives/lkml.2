Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0JFVdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:33:53 -0400
Received: from tex.lwn.net ([70.33.254.29]:50618 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab0JFVdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:33:52 -0400
Date: Wed, 6 Oct 2010 15:33:50 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] initial suspend and resume support
Message-ID: <20101006153350.7e506f5f@bike.lwn.net>
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 05:01:22 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> this little patch series finally adds basic suspend and resume support.
> The good thing is, that it nearly works.

I finally got around to taking a quick look at this.  It looks fine as
far as it goes, though I'd be tempted to take out the intermediate
steps and reduce the code churn a bit.

I need to dig out the more general suspend/resume stuff I have buried
in one of my trees, we'll need it at some point.  In the mean time, I
see no reason not to go ahead with this work.

Thanks,

jon
