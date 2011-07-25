Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1GYNOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1GYNOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:14:12 -0400
Subject: Re: [RFC 1/4] kbuild: export MAKECMDGOALS
From: Steven Rostedt <srostedt@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E258FAE.6040807@suse.cz>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	 <1309563076-5050-2-git-send-email-lacombar@gmail.com>
	 <CACqU3MU1kFzn9916A8vq+jB+r=4iDmWp_kk=E+thPuojWwZA6g@mail.gmail.com>
	 <4E258FAE.6040807@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 25 Jul 2011 09:14:00 -0400
Message-ID: <1311599640.3064.0.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 16:07 +0200, Michal Marek wrote:
> On 18.7.2011 21:05, Arnaud Lacombe wrote:
> > Hi,
> >
> > On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe<lacombar@gmail.com>  wrote:
> >> Cc: Steven Rostedt<srostedt@redhat.com>
> >> ---
> >>   Makefile |    3 +++
> >>   1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index afb8e0d..ea517fd 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -22,6 +22,9 @@ LC_COLLATE=C
> >>   LC_NUMERIC=C
> >>   export LC_COLLATE LC_NUMERIC
> >>
> >> +# Export make goals
> >> +export MAKECMDGOALS
> >> +
> >>   # We are using a recursive build, so we need to do a little thinking
> >>   # to get the ordering right.
> >>   #
> > Michal, before I send a new version of this serie, can you tell me
> > your point of view on the export of MAKECMDGOALS (or
> > KBUILD_MAKECMDGOALS) and Kconfig to the environment ?
> 
> A cleaner interface would IMO be to check the target in the makefile and 
> pass a commandline option to streamline_config.pl, so that it's easier 
> to run it manually.

I agree with this. As I've been told by many people that they prefer to
run streamline_config.pl directly.

-- Steve


