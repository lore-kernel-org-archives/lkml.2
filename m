Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1LBXrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:47:05 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55953 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab1LBXrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:47:03 -0500
X-Sasl-enc: F/lBWPXgrXzZXqq2TbWDMDsQoI6A5cCLf9hhMoewcgj8 1322869622
Date: Fri, 2 Dec 2011 15:45:12 -0800
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, linux-stable <stable@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86, amd: Avoid cache aliasing penalties on AMD
 family 15h
Message-ID: <20111202234512.GA3818@kroah.com>
References: <20111104112209.GB8020@aftab>
 <1320405995-10199-1-git-send-email-bp@amd64.org>
 <20111104152532.GB29754@kroah.com>
 <20111116232136.GA3533@kroah.com>
 <4EC69BD9.90902@zytor.com>
 <20111128000103.GB2304@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128000103.GB2304@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:01:03AM +0900, Greg KH wrote:
> On Fri, Nov 18, 2011 at 09:54:33AM -0800, H. Peter Anvin wrote:
> > On 11/16/2011 03:21 PM, Greg KH wrote:
> > > 
> > > Ping?
> > > 
> > > anyone?
> > > 
> > > greg k-h
> > 
> > Looking at it now...
> 
> Any thoughts?

Ok, given the long time here, and no response, I'm dropping them from my
queue.

Borislav, if you get the x86 maintainers ack, please feel free to resend
these.

greg k-h
