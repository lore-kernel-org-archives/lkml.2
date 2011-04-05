Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1DEMT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:19:56 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:56304 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DEMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:19:55 -0400
X-SENDER-IP: [85.230.173.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuNEAIwIm01V5q1yPGdsb2JhbACJFJxUCwEBAQE3MsMlDYVeBJEL
X-IronPort-AV: E=Sophos;i="4.63,304,1299452400"; 
   d="scan'208";a="178496073"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Apr 2011 14:20:16 +0200
To: Jeff Brown <jeffbrown@android.com>
Cc: dmitry.torokhov@gmail.com, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@google.com>
Subject: Re: [PATCH v2 2/4] hid: hid-input: Remove obsolete default events
 per packet setting.
Message-ID: <20110405122016.GA19455@polaris.bitmath.org>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-2-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301727259-5185-2-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 11:54:17PM -0700, Jeff Brown wrote:
> From: Jeff Brown <jeffbrown@google.com>
> 
> The hardcoded default is no longer needed because the input core now
> calculates an appropriate value when the input device is registered.
> 
> Signed-off-by: jeffbrown@android.com
> ---

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
