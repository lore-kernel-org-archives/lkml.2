Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab2JAXhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:37:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55007 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab2JAXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:37:09 -0400
Date: Mon, 1 Oct 2012 19:37:04 -0400
From: Jamie Gloudon <jamie.gloudon@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20121001233704.GA1344@darkstar>
References: <20121001161151.GA2640@darkstar>
 <20121001162745.GD23181@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001162745.GD23181@x1.osrc.amd.com>
User-Agent: Mutt/ (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like a better alternative to microcode_ctl which some distros don't
contain. 

Regards,
Jamie Gloudon

On Mon, Oct 01, 2012 at 06:27:45PM +0200, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 12:11:51PM -0400, Jamie Gloudon wrote:
> > Hey,
> > 
> >   Any chance of this getting merge for the 3.7 cycle? 
> 
> It is not ready yet: http://marc.info/?l=linux-kernel&m=134910582107898
> 
> Out of curiosity: why do you nee it?
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
