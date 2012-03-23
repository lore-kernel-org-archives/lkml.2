Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab2CWTWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:22:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54412 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546Ab2CWTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:21:55 -0400
Date: Fri, 23 Mar 2012 19:21:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Holland <bandidoirlandes@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop
 3.3.0-030300-generic
Message-ID: <20120323192152.GA27457@srcf.ucam.org>
References: <CAMfrEMa65+X1zA5fQ7R+Zt8tGjf9XtcHnPodiJgy+9bwO-nFkg@mail.gmail.com>
 <CADLC3L2XSJoPtt3g+GAc=JvMz3OjFewnt-BPBPyrVG+ZcxvW4w@mail.gmail.com>
 <20120323162930.GB23376@srcf.ucam.org>
 <CAMfrEMb9R8V=VagAzi1DJWXrSOJ-dSptdt9aQX=_igjBXF1USw@mail.gmail.com>
 <20120323165118.GA24014@srcf.ucam.org>
 <CAMfrEMa6EAsLMMvG-Yq03E0Qhc7jdk2WH5fvQUB16W-5=Qgfbw@mail.gmail.com>
 <20120323172053.GA24571@srcf.ucam.org>
 <CAMfrEMYFMtSuWPwJ+YVMEBAWwR7tAmrNrSqOhHAZmZAmR6D7yQ@mail.gmail.com>
 <20120323191716.GA27307@srcf.ucam.org>
 <CAMfrEMbhQCFAFG-RFhHcRQiZMNYPpT-MbA6hHsDHu-Y_51bYSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMfrEMbhQCFAFG-RFhHcRQiZMNYPpT-MbA6hHsDHu-Y_51bYSg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 02:20:46PM -0500, Chris Holland wrote:
> On Fri, Mar 23, 2012 at 2:17 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Ok, so applying this on an otherwise broken kernel makes it all work?
> >
> > --
> > Matthew Garrett | mjg59@srcf.ucam.org
> 
> Looks like it. If I did things correctly. How would I check and make sure?
> Start fresh, patch, and rebuild?

As long as you were starting with the 3.3 source and hadn't reverted 
anything, that's fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
