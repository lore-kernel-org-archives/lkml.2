Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2BELGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:06:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BELGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:06:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
Date: Sun, 5 Feb 2012 12:09:53 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Hillf Danton <dhillf@gmail.com>, Tejun Heo <tj@kernel.org>, pavel@ucw.cz,
        len.brown@intel.com, linux-pm@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <CAJd=RBDz6bm-2p28506+0CuC3P6kED8kXLrZe_TPuhTQSUo67w@mail.gmail.com> <4F2E608B.9000904@linux.vnet.ibm.com>
In-Reply-To: <4F2E608B.9000904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202051209.53667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 05, 2012, Srivatsa S. Bhat wrote:
> On 02/05/2012 11:36 AM, Hillf Danton wrote:
> 
> > On Sun, Feb 5, 2012 at 6:27 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Saturday, February 04, 2012, Srivatsa S. Bhat wrote:
> >>> On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:
> >>> Hi Rafael,
> >>>
> >>> I have reworked the changelog of this patch to indicate that this fixes a
> >>> regression. Here is the updated patch:
> >>
> >> Well, I've already fixed that up in my tree, but thanks anyway. :-)
> >>
> > 
> > Nicer if gurus open wider windows for patches received, no?
> > 
> 
> 
> I am not quite sure what you meant by that, but just in case you got the
> wrong idea by any chance, let me clarify:
> 
> Working with Rafael has *always* been an immensely pleasurable experience!
> There is absolutely no doubt in that :-)

Well, thanks! :-)

Rafael
