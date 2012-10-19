Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2JSQBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:01:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49269 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127Ab2JSQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:01:06 -0400
Date: Fri, 19 Oct 2012 11:48:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Is: Xen architecture document. Was: Re: [Xen-devel] Is: axe
 read_tscp pvops call. Was: Re: [RFC] ACPI S3 and Xen (suprisingly small\!).
Message-ID: <20121019154854.GO26830@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <507ED6C0.4020503@zytor.com>
 <20121017161036.GA10691@phenom.dumpdata.com>
 <507EE1C3.7070300@zytor.com>
 <20121017165452.GA22740@phenom.dumpdata.com>
 <507EEC53.1010309@zytor.com>
 <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default>
 <50802030.8070107@zytor.com>
 <dd8748de-4715-499a-8c7e-745af37fa6c4@default>
 <50803057.5000307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50803057.5000307@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> paravirtualized architectures out there which are perfectly well
> documented and supportable, but Xen has resisted doing that for
> years, and all we ever get are vague future promises.

There is no resistance - and it is being done. Every month we document
various APIs, man-pages, etc so that knowledge won't be lost. The
end-result of that is to create a PDF similar to the PowerPC architecture
document.

I have not been pointing you to it, b/c as of right what we have is
raw data (various header files growing in size) that keep on growing.
I need to hire/cajole an editor to help us get from the "raw" brain
dump to a book and some sense of milestones/schedule or whatever one
does in the book-world.

And Peter, just in case it is not clear, every suggestion you make is
appreciated and taken seriously. If there are things that have been
dropped or forgotten by me - please remind me.
