Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1EQDlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 23:41:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48199 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1EQDlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 23:41:32 -0400
Message-ID: <4DD1EE54.9040201@interlog.com>
Date: Mon, 16 May 2011 23:41:08 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Milburn <dmilburn@redhat.com>,
        "Ciechanowski, Ed" <ed.ciechanowski@intel.com>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Danecki, Jacek" <jacek.danecki@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Subject: Re: [GIT PULL] isci merge candidate
References: <1305317680.21099.83.camel@dwillia2-linux>	<BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>	<4DCDA663.2040202@intel.com>	<1305324962.2781.5.camel@pasglop>	<BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com> <BANLkTi=yGe+xKpB+VnD3+tvw1-o4Qs_Z7w@mail.gmail.com>
In-Reply-To: <BANLkTi=yGe+xKpB+VnD3+tvw1-o4Qs_Z7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-16 08:47 PM, Jeff Garzik wrote:
> On Mon, May 16, 2011 at 8:39 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>> At a minimum It would require a more verbose interface to
>> libsas/libata (or new libframe?) to allow us to deliver raw
>> unsolicited frames into common protocol handlers.
>
>   ...which is where SAS and SATA have been heading for a while, anyway.
>   With chained SAS expander setup you have a network, if an annoying,
> manually configured and routed one.  Over that network you deliver
> frames of various types.

For SAS-2 expanders, edit the above to:
s/manually/self/

Doug Gilbert

