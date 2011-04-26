Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1DZPxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:53:17 -0400
Received: from imr4.ericy.com ([198.24.6.8]:58581 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab1DZPxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:53:15 -0400
Date: Tue, 26 Apr 2011 08:53:04 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH v2 2/3] thermal: Split hwmon lookup to a separate
 function
Message-ID: <20110426155304.GD18176@ericsson.com>
References: <20110426165600.1d9ac91b@endymion.delvare>
 <20110426170253.58f05975@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110426170253.58f05975@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 11:02:53AM -0400, Jean Delvare wrote:
> We'll soon need to reuse it.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rene Herman <rene.herman@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

