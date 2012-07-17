Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab2GQUqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:46:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2GQUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:46:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: PM: Summary of changes for v3.6
Date: Tue, 17 Jul 2012 22:52:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Cross <ccross@android.com>
References: <201207162246.03660.rjw@sisk.pl> <87mx2zcq62.fsf@ti.com>
In-Reply-To: <87mx2zcq62.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207172252.06093.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, July 17, 2012, Kevin Hilman wrote:
> Rafael, Daniel,
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Hi all,
> >
> > All of the changes I'd like to include into the first PM pull request during
> > the v3.6 merge window, except maybe for one or two patches I know are in the
> > works, is on the 'linux-next' branch of the linux-pm.git tree now.  The summary
> > of those changes is appended.  If anyone finds any of them objectionable,
> > please let me know ASAP.  Also please let me know if you have any power
> > management patches you'd like me to take for v3.6.
> >
> 
> Could someone please clarify the status of the coupled CPUidle series?  
> 
> There's a version of these in Daniels cpuidle-next branch and there's a
> version of these in Len's next branch (included in linux-next), but I'm
> still not entirely sure which branch is going upstream and which branch
> has the latest version (but I think Daniel's is the latest)

Colin says that the commits in the Len's tree match his latest version,
so I think those commits should be merged, since they have been present
in that tree since the 3.5 merge window.

Thanks,
Rafael
