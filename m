Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1FLFcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 01:32:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42887 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab1FLFcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 01:32:45 -0400
X-Sasl-enc: 9OtT2ig29/MKNzx9z3PU01aiW08TzycjCThF1N813Jxe 1307856764
Date: Sat, 11 Jun 2011 22:32:15 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4]Documentation/zh_CN: Remove messy code
 documentations and rebuild new documentations
Message-ID: <20110612053215.GA18418@kroah.com>
References: <20110611023749.GA2101@gmail.com>
 <20110611200513.GA14582@kroah.com>
 <20110612025319.GA2035@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612025319.GA2035@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 10:53:21AM +0800, Harry Wei wrote:
> On Sat, Jun 11, 2011 at 01:05:13PM -0700, Greg KH wrote:
> > On Sat, Jun 11, 2011 at 10:37:52AM +0800, Harry Wei wrote:
> > > From: Harry Wei <harryxiyou@gmail.com>
> > > 
> > > There are two messy code documentations in our
> > > Documentation/zh_CN/ directory. They are
> > > Documentation/zh_CN/email-clients.txt &
> > > Documentation/zh_CN/SubmitChecklist.
> > > The following patches can fix them.
> > > 
> > > Harry Wei (4)
> > > Documentation/zh_CN: remove messy code file email-clients.txt
> > > Documentation/zh_CN: remove messy code file SubmitChecklist
> > > Documentation/zh_CN: add new file email-clients.txt
> > > Documentation/zh_CN: add new file SubmitChecklist
> > 
> > Why are you deleting and then adding back the files?  
> > Why not just edit them and change them in one single patch?
> Hmmm..., what about two patches? One for editing and changing 
> email-clients.txt and the other one for editing and changing 
> SubmitChecklist.

That is fine, I'll queue them up in a few days.

greg k-h
