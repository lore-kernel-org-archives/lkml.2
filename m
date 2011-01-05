Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1AEEgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:36:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:47252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1AEEgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:36:40 -0500
Subject: Re: declare MODULE_FIRMWARE in libsas
From: James Bottomley <James.Bottomley@suse.de>
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D23E315.9060900@oracle.com>
References: <4D22CF9F.1070005@oracle.com>
	 <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>
	 <4D23E315.9060900@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 22:36:32 -0600
Message-ID: <1294202192.7879.30.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:18 +0800, DuanZhenzhong wrote:
> Jeff Garzik 写道:
> > On 01/04/2011 09:08 AM, James Bottomley wrote:
> >> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
> >>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
> >>>
> >>> ---
> >>
> >> Description?  Since libsas has no firmware, surely some explanation is
> >> required.
> >
> > Indeed.  Looks bogus at first glance?
> >
> >
> I was finding all requested but not exported firmware in scsi driver for 
> generating dump initrd use.
> In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_addr 
> neither builtin nor exported. Don't sas_addr a firmware? Please correct 
> me. thanks

No, it's not requesting any firmware ... it's a slight misuse of the
firmware mechanism that allows a libsas based driver to be given a SAS
address if it doesn't have an internal nsvram to store one.

James


