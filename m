Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1DDMJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:09:36 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:51050 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1DDMJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:09:34 -0400
X-Greylist: delayed 1171 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 08:09:34 EDT
X-SENDER-IP: [85.230.173.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqRQAF+vmU1V5q1yPGdsb2JhbACJEpxKCwEBAQE3Mr98DYVeBJEJ
X-IronPort-AV: E=Sophos;i="4.63,296,1299452400"; 
   d="scan'208";a="1401133"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 4 Apr 2011 13:50:24 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
Message-ID: <20110404115024.GA1783@polaris.bitmath.org>
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 05:03:39PM -0400, Chase Douglas wrote:
> The evdev buffer isn't big enough when you get many fingers on the
> device. Bump up the buffer to a reasonable size, matching what other
> multitouch devices use. Without this change, events may be discarded in
> the evdev buffer before they are read.
> 
> Reported-by: Simon Budig <simon@budig.de>
> Cc: Henrik Rydberg <rydberg@euromail.se>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: stable@kernel.org
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---

Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, Chase.

Henrik
