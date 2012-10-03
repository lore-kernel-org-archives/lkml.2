Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2JCMYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:24:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45885 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab2JCMYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:24:30 -0400
Message-ID: <1349267066.2404.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/5]  SCSI: Re-name the HBA Type
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: NickCheng <nick.cheng@areca.com.tw>
Cc: jejb@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Oct 2012 13:24:26 +0100
In-Reply-To: <BAB7693390984FB1BCBDB8E788883AAD@arecaaebe11fae>
References: <BAB7693390984FB1BCBDB8E788883AAD@arecaaebe11fae>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 20:14 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
> 
> Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

Please send these to the SCSI mailing list: linux-scsi@vger.kernel.org

With a proper subject (which is <driver>:).

And a proper signed off by (you need a space between your name and the
opening < and no space within).

Thanks,

James


