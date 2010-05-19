Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0ESIPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:15:37 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:48192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0ESIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:15:35 -0400
Subject: Re: collecting static data related to tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100519072838.GD5704@nowhere>
References: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
	 <1274193698.26328.746.camel@gandalf.stny.rr.com>
	 <1274193909.31554.12.camel@jlt3.sipsolutions.net>
	 <20100519072838.GD5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 10:15:31 +0200
Message-ID: <1274256931.3874.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:28 +0200, Frederic Weisbecker wrote:

> > Sounds good, although it does require that I tell people who want to
> > record to also install the recording plugin, but that should be
> > manageable :) I can just dig out the data from the regular debugfs once
> > I add files containing it.

> This is a place where events injection might be suitable perhaps.
> Either kernel or user space event injection.
> 
> kernel space injection would be a simple trace event declared that
> have a callback called when it gets enabled. This callback would
> inject any events it wants.

Indeed, that is a good point, and it would also allow us to handle
hotplugging with the same event by sending it when a new device shows
up, and additionally when it is enabled to dump the current state.

johannes

