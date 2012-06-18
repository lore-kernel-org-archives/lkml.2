Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2FROfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:35:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2FROfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:35:10 -0400
Message-ID: <4FDF3C9B.5060502@gmail.com>
Date: Mon, 18 Jun 2012 08:35:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, weisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>  <87lijlhv9v.fsf@sejong.aot.lge.com> <1340029292.25903.101.camel@gandalf.stny.rr.com>
In-Reply-To: <1340029292.25903.101.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/12 8:21 AM, Steven Rostedt wrote:
>
> Anyway, I think it is important to get this into either libtraceevent or
> another library, but I agree with Namhyung that it should not go in, in
> its current form.

Great. No resistance to bringing this in.

> Either we add the 'pevent_' names to it, and we need to change things a
> bit.

Sure, namespace cleanup is trivial.

> I want to redesign the plugin interface. Well, I do not need to be the
> one to redesign it, but it needs to be updated by someone.
>
> Plugins need an interface that they can take parameters, or be modified
> at run time. An option passed to perf or trace-cmd could modify how the
> plugin works. Or during viewing of the output, parameters can be passed
> to tell plugins to do things differently.
>
> Basically, we need to discuss the interface between plugins and the
> libtraceevent library. Once we get a good idea of what is needed, then
> we can start reusing the code from trace-cmd to make a much better
> interface for users.

Ok. I'll poke around with this over the summer as I get spare time.

David
