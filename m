Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2IMKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:03:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42859 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2IMKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:03:31 -0400
Date: Thu, 13 Sep 2012 13:02:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/5] Staging: ipack/devices/ipoctal: acknowledge BREAK
 condition.
Message-ID: <20120913100250.GM19396@mwanda>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
 <1347529588-21212-4-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347529588-21212-4-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:46:27AM +0200, Samuel Iglesias Gonsalvez wrote:
> Clear the BREAK flag from the ISR register.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

What are the user visible effects of this bugfix?

regards,
dan carpenter

