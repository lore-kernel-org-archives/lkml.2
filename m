Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0LIPs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:48:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:33121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0LIPs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:48:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="866374323"
Date: Thu, 9 Dec 2010 16:48:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        ben-linux@fluff.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/20] mfd/tc3589x: add block identifier for multiple
 child devices
Message-ID: <20101209154809.GU8884@sortiz-mobl>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
 <1291388753-14662-10-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291388753-14662-10-git-send-email-sundar.iyer@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Fri, Dec 03, 2010 at 08:35:42PM +0530, Sundar Iyer wrote:
> Add block identifier to be able to add multiple mfd clients
> to the mfd core

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
