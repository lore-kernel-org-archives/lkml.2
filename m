Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396Ab2CWUMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:12:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55190 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2CWUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:12:54 -0400
Date: Fri, 23 Mar 2012 20:12:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Holland <bandidoirlandes@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop
 3.3.0-030300-generic
Message-ID: <20120323201251.GA28567@srcf.ucam.org>
References: <20120323162930.GB23376@srcf.ucam.org>
 <CAMfrEMb9R8V=VagAzi1DJWXrSOJ-dSptdt9aQX=_igjBXF1USw@mail.gmail.com>
 <20120323165118.GA24014@srcf.ucam.org>
 <CAMfrEMa6EAsLMMvG-Yq03E0Qhc7jdk2WH5fvQUB16W-5=Qgfbw@mail.gmail.com>
 <20120323172053.GA24571@srcf.ucam.org>
 <CAMfrEMYFMtSuWPwJ+YVMEBAWwR7tAmrNrSqOhHAZmZAmR6D7yQ@mail.gmail.com>
 <20120323191716.GA27307@srcf.ucam.org>
 <CAMfrEMbhQCFAFG-RFhHcRQiZMNYPpT-MbA6hHsDHu-Y_51bYSg@mail.gmail.com>
 <20120323192152.GA27457@srcf.ucam.org>
 <CAMfrEMbcy-s1WiJqDCDb6BywDzR4HW77i0V7e9B_yRMweQZKCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMfrEMbcy-s1WiJqDCDb6BywDzR4HW77i0V7e9B_yRMweQZKCg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 03:10:14PM -0500, Chris Holland wrote:

> I think I had the commit 4949be16822e92a18ea0cc1616319926628092ee
> removed when I applied the patch.
> 
> I did a
> git reset --hard v3.3
> applied the patch and am rebuilding.

Thanks - let me know if it helps!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
