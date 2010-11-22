Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0KVRCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:02:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57855 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0KVRCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pt5zZ0qV/TVgIYN3Y5JK8fFxSHLsFPrkYwbVtIMJMDkisxB9AmfKxojIeFddHLglFO
         YMe+d9IZ8aQCRfFOTvoA11qJVECa5bJyeH8KTN+/2Azr4zakp1d6v62ro2pNGQnOMgXD
         AxJVsSknSmqG2Or0hhRiKikvfo1pmTrUvNkjI=
Date: Mon, 22 Nov 2010 20:02:42 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Dan J. Rosenberg" <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re:
Message-ID: <20101122170242.GA11289@albatros>
References: <3E0D78C2-CEAF-42C3-9840-20B01AA4EFC7@vsecurity.com>
 <9A449BDC-E014-406A-84BD-D0C1F2DFD928@vsecurity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A449BDC-E014-406A-84BD-D0C1F2DFD928@vsecurity.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 13:33 -0500, Dan J. Rosenberg wrote:
> In this case, count can never be -1, since it's limited by various checks in vfs_write() and rw_verify_area(), etc.

Correct, I was dummied by similar checks in similar drivers - they do
check such overflows.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
