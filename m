Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2JINet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:34:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58683 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755750Ab2JINeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:34:44 -0400
Message-ID: <1349789680.2615.80.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/5]  arcmsr: Re-name the HBA Type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org
Date: Tue, 09 Oct 2012 14:34:40 +0100
In-Reply-To: <E46872A6894149C9B846DBC819D437F5@arecaaebe11fae>
References: <E46872A6894149C9B846DBC819D437F5@arecaaebe11fae>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 21:23 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
> 
> Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

This is still malformed in exactly the same way

> diff -uprN -X linux-vanilla/Documentation/dontdiff
> linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
> linux-development//drivers/scsi/arcmsr/arcmsr.h
> --- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03

There's a spurious carriage return here which kills the patch
applicability

> 18:29:18.030657090 +0800

James


