Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0GIQw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:52:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44369 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab0GIQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GK8LszRunQKmBTDnlgkRRhN8EkDchjopbQxzjzCAVQYi8pKavcJQ9HFUwg4H1//pep
         Fl4XAbou3Ajz90fOJP6NbGQaBlPPhaxUyAiNtJbwc5fO9vEkAMkf7p9wN9Q34enVepZs
         lTceehl8i6qMJv/9D+48ZlB4Es4LNTtmpp5Ps=
MIME-Version: 1.0
In-Reply-To: <1278684193.1537.135.camel@gandalf.stny.rr.com>
References: <loom.20100705T144459-919@post.gmane.org> <20100708132237.GA22830@goodmis.org> 
	<AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com> 
	<1278645989.1537.133.camel@gandalf.stny.rr.com> <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com> 
	<20100709130454.GC5291@nowhere> <1278684193.1537.135.camel@gandalf.stny.rr.com>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Fri, 9 Jul 2010 19:52:05 +0300
Message-ID: <AANLkTinQYgKRXdlac4Gy7qJjmLkz_ew_-gIRksoIF8oT@mail.gmail.com>
Subject: Re: 2.6.35 regression
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 17:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> Zeev, can I add your "Tested-by:" tag, and Frederic your "Acked-by:"?

Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>
