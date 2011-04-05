Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1DEMQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:16:22 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:39939 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DEMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:16:20 -0400
X-SENDER-IP: [85.230.173.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuNEAGcHm01V5q1yPGdsb2JhbACJFJxUCwEBAQE3MsMrDYVeBJEL
X-IronPort-AV: E=Sophos;i="4.63,304,1299452400"; 
   d="scan'208";a="179976780"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Apr 2011 14:16:45 +0200
To: Jeff Brown <jeffbrown@android.com>
Cc: dmitry.torokhov@gmail.com, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@google.com>
Subject: Re: [PATCH v2 1/4] input: Set default events per packet.
Message-ID: <20110405121645.GB19391@polaris.bitmath.org>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 11:54:16PM -0700, Jeff Brown wrote:
> From: Jeff Brown <jeffbrown@google.com>
> 
> Calculate a default based on the number of ABS axes, REL axes,
> and MT slots for the device during input device registration.
> 
> Signed-off-by: jeffbrown@android.com
> ---

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
