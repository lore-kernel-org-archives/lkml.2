Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1EQKMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:12:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48693 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab1EQKMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:12:35 -0400
Subject: Re: [PATCH 16/16] hpsa: add P2000 to list of shared SAS devices
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
In-Reply-To: <20110503200007.5478.88000.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
	 <20110503200007.5478.88000.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 14:12:27 +0400
Message-ID: <1305627148.6008.24.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 15:00 -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Signed-off-by: Scott Teel <scott.stacy.teel@hp.com>

Just FYI for future, this is missing your signoff.; it needs to be there
because you're sending me the patch.  I also suspect this patch is
actually by Stott Teel?  In which case it should show as From: him.

James


