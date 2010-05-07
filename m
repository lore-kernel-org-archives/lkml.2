Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0EGNWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0EGNWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:22:08 -0400
Subject: Re: fanotify issues in 2.6.34-rc6-next-20100506
From: Eric Paris <eparis@redhat.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4BE3DC60.7080105@control.lth.se>
References: <4BE3DC60.7080105@control.lth.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 09:21:51 -0400
Message-ID: <1273238511.15368.189.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:24 +0200, Anders Blomdell wrote:

> seems to lose/corrupt events. For instance running 'fanotify -c /dir/to/watch'
> and then running the command 'cd /dir/to/watch ; touch a b c d e f g h i j k l'
>  might generate (results are more or less random):

I'm looking at it right now, not sure what's going on, probably screwed
up the even merging logic....

