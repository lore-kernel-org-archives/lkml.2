Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2KNHC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:02:56 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55975 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab2KNHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:02:54 -0500
Message-ID: <1352813997.2505.10.camel@dabdike.sthat4.btopenzone.com>
Subject: Re: [PATCH 1/5]  arcmsr: Re-name the HBA Type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org
In-Reply-To: <E0E58D26E0F44C3580C13BBDE76CBB5D@arecaaebe11fae>
References: <E0E58D26E0F44C3580C13BBDE76CBB5D@arecaaebe11fae>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Nov 2012 13:39:57 +0000
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 17:05 +0800, NickCheng wrote:
> -#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK        0x00000004 /*
> When clear, the General Outbound Doorbell interrupt routes to
> the host.*/
> 
The patch is still linebroken here.  It is a massively long line (like
about 200 characters).  I suspect you just set your exchange server line
break to something big, but not bigger than this?

James


