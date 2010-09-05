Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab0IEF4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 01:56:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0IEF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 01:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b7NdyxznXqRWz+M7uUeMpkIkhz7/+MmlfzPRxpDATMqEVlOJqGVvB8QS3f7aaH9h5J
         Y7S/vgfmuOZHvr2DMNvo5DAEZuO5CdD/EydrM2v4k6M6vO6gjCeWFrk2TOuX9t8G0/Zt
         USpOSUQflp1ncg/EZ9+wRKrGVrPPwNknlNPRI=
Date: Sun, 5 Sep 2010 07:56:21 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Christian Riesch <christian.riesch@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100905055621.GA2699@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <alpine.DEB.2.00.1009041221240.888@router.home>
 <4C828652.4060804@gmail.com>
 <alpine.DEB.2.00.1009042036540.9425@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009042036540.9425@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 08:37:22PM -0500, Christoph Lameter wrote:
> On Sat, 4 Sep 2010, Christian Riesch wrote:
> 
> > Richard's idea is to support clock hardware for IEEE 1588 (PTP, Precision Time
> > Protocol). Have a look at the earlier discussions:
> 
> Ok great. A summary of that belongs into the intro of the patchset.

I left off all mention of PTP, since Alan Cox said that all this talk
of PTP is not helpful. I think that the idea is introduce a method to
tune a clock referenced by its clockid_t. In other words, a patch for
tuning posix clocks, just as the subject lines indicate.

Richard

