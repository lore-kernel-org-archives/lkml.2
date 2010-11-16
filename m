Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0KPU2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:28:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0KPU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:28:45 -0500
Message-ID: <4CE2E985.4050102@vlnb.net>
Date: Tue, 16 Nov 2010 23:28:53 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: SCSI TMF processing; tag allocation
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <20101113123750.GF18258@parisc-linux.org>
In-Reply-To: <20101113123750.GF18258@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:l73zcBhYrS5iGxxs+K2kz7x9fereWHYQDXRUH29hlWm
 zM+S+FcdDV00ZT6DqbCT1ONCntWe21YLmh4aOABdOpMKEyWVgK
 N5n0gYI+fSaxj2E/Rkzs2XZ7rydO6W77D72tX9MM3DirNWrI50
 Yv56ELNhBrHgNXQ5arLgnHc2lRQRP1xbXIpFPvQY1tLYR52MoX
 yQEHj698GLUdnTEG/YfHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox, on 11/13/2010 03:37 PM wrote:
> SPC-4 seems to indicate (in the INQUIRY command, 6.4.2) that support
> for queueing is now non-optional, and even support for basic queueing
> has been removed, replaced only with the 'command management model'.
> I must confess to being somewhat confused by the difference between the
> 'basic queue' model and 'command management' model

The 'command management model' is what was called 'full task management
model' in SAM-3. The difference of it with 'basic task management model'
in SAM-3 is that (basically) in the latter:

 - Support only for SIMPLE or ORDERED commands (not both)

 - For SIMPLE commands their reorder can't be controlled

 - On any error all queued commands must be aborted and this behavior
can't be controlled.

Vlad

