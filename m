Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0EROpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:45:14 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab0EROpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:45:11 -0400
Subject: Re: collecting static data related to tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: rostedt@goodmis.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1274193698.26328.746.camel@gandalf.stny.rr.com>
References: <1274191742.31554.10.camel@jlt3.sipsolutions.net>
	 <1274193698.26328.746.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 16:45:09 +0200
Message-ID: <1274193909.31554.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 10:41 -0400, Steven Rostedt wrote:

> The latest version of trace-cmd has an "options" section. This allows
> you to add options to the file.
> 
> We could make a plugin that also can be used by trace-cmd record, that
> allows you to add options. The options are written such that if a
> trace-cmd does not know how to deal with them, they will be ignored.
> 
> Hmm, but the options require a unique ID. Well we could register IDs
> with plugins, or add a plugin id, which uses the name of the plugin as
> an identifier too.
> 
> But this would allow you to add the details you want about the system
> and then have the reader be able to print it out.
> 
> How's that sound?

Sounds good, although it does require that I tell people who want to
record to also install the recording plugin, but that should be
manageable :) I can just dig out the data from the regular debugfs once
I add files containing it.

johannes

