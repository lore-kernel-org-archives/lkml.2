Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab2JSRpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60717 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2JSRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:45:48 -0400
Message-ID: <508191BD.4000107@zytor.com>
Date: Fri, 19 Oct 2012 10:45:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: Is: Xen architecture document. Was: Re: [Xen-devel] Is: axe read_tscp
 pvops call. Was: Re: [RFC] ACPI S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <507ED6C0.4020503@zytor.com> <20121017161036.GA10691@phenom.dumpdata.com> <507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com> <507EEC53.1010309@zytor.com> <84b3cbf9-7c84-4d7e-a2d7-46b0d1cc5975@default> <50802030.8070107@zytor.com> <dd8748de-4715-499a-8c7e-745af37fa6c4@default> <50803057.5000307@zytor.com> <20121019154854.GO26830@phenom.dumpdata.com>
In-Reply-To: <20121019154854.GO26830@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 08:48 AM, Konrad Rzeszutek Wilk wrote:
>> paravirtualized architectures out there which are perfectly well
>> documented and supportable, but Xen has resisted doing that for
>> years, and all we ever get are vague future promises.
> 
> There is no resistance - and it is being done. Every month we document
> various APIs, man-pages, etc so that knowledge won't be lost. The
> end-result of that is to create a PDF similar to the PowerPC architecture
> document.
> 
> I have not been pointing you to it, b/c as of right what we have is
> raw data (various header files growing in size) that keep on growing.
> I need to hire/cajole an editor to help us get from the "raw" brain
> dump to a book and some sense of milestones/schedule or whatever one
> does in the book-world.
> 
> And Peter, just in case it is not clear, every suggestion you make is
> appreciated and taken seriously. If there are things that have been
> dropped or forgotten by me - please remind me.
> 

Right... so for those who don't know, this is something I have discussed
with Konrad over the course of the last several years.  It is good to
know progress is happening.  It is late, of course -- this should have
happened before Xen was integrated -- but we can't change the past.

	-hpa
