Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab0JLVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:24:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4103 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab0JLVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:24:29 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Tue, 12 Oct 2010 14:17:26 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: "Suraj Sumangala" <Suraj.Sumangala@atheros.com>,
        "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
Message-ID: <20101012211726.GE2678@broadcom.com>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com>
 <20101008181508.GM10149@tux>
MIME-Version: 1.0
In-Reply-To: <20101008181508.GM10149@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 60AA0FED47822993520-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 11:15:08AM -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 08, 2010 at 10:27:36AM -0700, Suraj Sumangala wrote:
> > Marcel had answered me before. It makes sense to have same file name.
> > Other ways we end up changing the driver whenever there is a firmware 
> > change.
> 
> > > I last tried to document a thread we had over this here:
> > >
> > > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> > >
> 
> Thanks, I've updated that link above to document bug fixing does not require
> a filename change.

I don't really understand why you would not want to change the code revision
part of the filename.  

I totally agree that you don't want to change the driver every time the
firmware gets a bug fix, but wasn't that the whole point of splitting the name
into API and code revisions portions, and symlinking the file to one that just
has the API version?

What's the issue with using the process as originally documented?

- Henry


