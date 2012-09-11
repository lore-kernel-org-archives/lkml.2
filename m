Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2IKItf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:49:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47433 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2IKItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:49:33 -0400
Date: Tue, 11 Sep 2012 11:48:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 09/20] Staging: ipack: reset previous timeouts during
 device registration.
Message-ID: <20120911084844.GQ19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-9-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-9-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:51:47AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>

Please explain the user visible effects of this bug fix in the
changelog.  *grumble*.

regards,
dan carpenter

