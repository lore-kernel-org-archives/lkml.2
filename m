Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0JHFCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:02:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:36715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0JHFCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:02:07 -0400
Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
From: James Bottomley <James.Bottomley@suse.de>
To: bo yang <boyang1288@gmail.com>
Cc: bo.yang@lsi.com, linux-scsi@vger.kernel.org, akpm@osdl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com>
References: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 17:35:47 -0500
Message-ID: <1286490947.23573.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 22:50 -0400, bo yang wrote:
> Driver added the Device update flag to tell LSI application driver
> will do the device Update.  LSI MegaRAID SAS application will check
> this flag to decide if it is need to update the Device or not.

Well, the good news is I've got the Online Controller reset update. The
bad news is that this patch now fails to apply: looks like an attachment
problem again:

Applying: megaraid_sas: support devices update flag
fatal: corrupt patch at line 70
Patch failed at 0001 megaraid_sas: support devices update flag

James


