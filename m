Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1DZP3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:29:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48644 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab1DZP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iO5TiXqXEpEtnGdDnl2kQDut8Y4/nhqUP11JFyWhGyyOuUyQ+W0jp8Keiw6I+blmjb
         qy0t4/UJHvMCTB7jVS7Fkl/347OjoesdAy8B+GtzhyahqYl3DI9dUm8/SgkugBO2rnsm
         Jjwi5mfL/Cd7TZw9Nr0mGRA/lmra8V1OKIp6A=
Date: Tue, 26 Apr 2011 17:29:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
Message-ID: <20110426152908.GA2879@nowhere>
References: <201103311704.40372.roucaries.bastien@gmail.com>
 <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
 <4D9B3C10.9060704@suse.com>
 <BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
 <BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
 <BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
 <BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
 <20110411231843.GB2061@nowhere>
 <BANLkTinHk7fVi62_Xftwn_0WLOzkS4jggw@mail.gmail.com>
 <BANLkTikjD9hRPagnvjYO7A3ESGrwd1Qe-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikjD9hRPagnvjYO7A3ESGrwd1Qe-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:01:48AM +0200, Bastien ROUCARIES wrote:
> On Tue, Apr 12, 2011 at 2:01 PM, Bastien ROUCARIES
> <roucaries.bastien@gmail.com> wrote:
> > On Tue, Apr 12, 2011 at 1:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> On Mon, Apr 11, 2011 at 10:40:18AM +0200, Bastien ROUCARIES wrote:
> >>> Any news ? Can I test some patch ?
> Do you achieve to reproduce it ?
> 
> Do you want I test something ?

So I've run 8 parallel loops of git reset / git merge in 8 different
repos during 2 days but I've been unable to reproduce.

I'm going to retry the same with kmail. What kind of thing do you make
with kmail for this to trigger? Can you also resend me your config
because I can't retrieve it from our discussion.

Thanks.
