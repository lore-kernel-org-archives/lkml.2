Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0DOUNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:13:25 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62540 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab0DOUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G4BefwrODDrRP4S+BqpBSJiriVArPgHt1Ia2nmrYJtV4EG0LZlJEivasofIDWhCpoA
         OBAxdb9ajfaq54EfBC1ORaGtSkFfOX7SrYHtPfU7H6bmHjBtSJvNrai2DfSs47TJHq4F
         MB3AfYNpJW2E35T8Hm6o/Zws7spuSt8GhZVp0=
Date: Thu, 15 Apr 2010 22:13:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/3 v4] Add tracing_off_event() to stop tracing when a
	bug or warning occur
Message-ID: <20100415201319.GE5069@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:20:14PM -0400, Chase Douglas wrote:
> The tracing_off_event() function calls tracing_off() to stop tracing
> when an event occurs. By default, only BUG-type events stop tracing,
> while WARNING type events do not. This is controlled through the
> tracing_off={none,warn,bug} commandline parameter.
> 
> Call this function from bug and warning event handlers to enable a user
> to debug their kernel by starting a trace, hitting an event, and then
> retrieving trace info knowing that the trace was stopped right after the
> event was hit.


That's a good idea!


> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

