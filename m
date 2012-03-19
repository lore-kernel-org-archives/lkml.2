Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2CSABs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:01:48 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:54200
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537Ab2CSABp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:01:45 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275bh8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH RESEND  0000/0002] drivers: scsi: storvsc 
Thread-Topic: [PATCH RESEND  0000/0002] drivers: scsi: storvsc 
Thread-Index: AQHNBUC3oPTVEpE8Ske4W4ZUMfOD5ZZwu0BQ
Date: Mon, 19 Mar 2012 00:01:17 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B767CB5@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1332100789-25594-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop these two patches. It looks like I sent out the wrong set of patches.
I will send the ones I wanted to send shortly.

Regards,

K. Y

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, March 18, 2012 4:00 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan
> Subject: [PATCH RESEND 0000/0002] drivers: scsi: storvsc
> 
> 
> The current Windows hosts only handle a subset of scsi commands
> sent from the guest and for commands that are not supported, they are
> filtered on the host side a generic failure is returned to the guest
> as SRB status. The returned error code does not permit the guest to
> figure out if there was an error or if the command was not supported.
> 
> Based on the input I got from the community, I have convinced the windows
> developers to return an error code that allows the guest to distinguish between
> unsupported command and true failures. However, it is not clear when this fix
> will
> be shipped.
> 
> This patch set addresses this issue by filtering the ATA_16 command on the guest
> (note that currently the host is filtering this command as it is not supported).
> I also have a patch here the correctly handles SRB_STATUS_INVALID_REQUEST
> error returns - note that the current windows hosts don't return this today.
> 
> This is a resend of the patches sent earlier based on suggestions from
> Jeff Garzik <jgpobox@gmail.com> and Douglas Gilbert <dgilbert@interlog.com>.
> 
> 
> Regards,
> 
> K. Y


