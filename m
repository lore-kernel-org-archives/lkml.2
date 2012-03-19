Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032419Ab2CSSQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:16:35 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59323 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031398Ab2CSSQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:16:34 -0400
Date: Mon, 19 Mar 2012 14:16:27 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, kosaki motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org, amwang@redhat.com, jslaby@suse.cz,
        ebiederm@xmission.com, joe korty <joe.korty@ccur.com>,
        dhowells@redhat.com
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
Message-ID: <79ac1725-6aa2-4d67-8b59-cbf752ea9f3e@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4F67749E.50208@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.23]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On 3/14/2012 5:45 PM, Doug Ledford wrote:
> > On 03/14/2012 05:38 PM, Andrew Morton wrote:
> >> On Wed, 14 Mar 2012 17:28:33 -0400
> >> Doug Ledford <dledford@redhat.com> wrote:
> >>
> >>> This has obviously fallen through the cracks.
> >>
> >> It sure has.  Please dig out whatever is the currently favored
> >> patchset, refresh, retest and resend, with changelogging which
> >> fully
> >> covers the reasoning and decision process?
> > 
> > OK, completely redoing patch set then against current Linus tree.
> > 
> > Motohiro, would you be so kind as to resend my your patches that
> > went on
> > top of mine and I'll create a complete patch set?
> 
> I'm sorry. I already have a rebased patch. but I haven't posted. I
> have to
> hurry.

Actually, I already pulled them from the lkml archives and fixed up
the one patch that didn't apply cleanly.  The only reason I haven't
sent the entire patchset out yet is that I'm writing a test/verification
app to go along with it.

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

