Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2ICRCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 13:02:25 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35206 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2ICRCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 13:02:24 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmZ3AHnhRFBV5qoUPGdsb2JhbABFhT+FAK9hBH8ZAQEBAR4ZDSeCIAEBBAE6HCMFCwgDRhQlChqIGgq6QhSLM4YJYAOVWIVvjRE
X-IronPort-AV: E=Sophos;i="4.80,361,1344204000"; 
   d="scan'208";a="186022446"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 3 Sep 2012 19:08:36 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 v3 00/20] Input and HID updates for 3.7
Message-ID: <20120903170836.GA817@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=GKQt7nZKNQP7Z8Y_mp_HaUGqhw9bat8RjCpC19S7H2FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GKQt7nZKNQP7Z8Y_mp_HaUGqhw9bat8RjCpC19S7H2FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed, we are getting close. I tested the whole patch set again.
> So:
> - patches 1 to 19 are not introducing any bugs (at least from what I've seen).
> - patch 20 is not good (see the reply in the patch).
> 
> So far, devices tested are:
> - Elan
> - 3M
> - Lumio
> - Cypress
> - Topseed
> - Stantum
> 
> you can add my "reviewed by" on patches 1, 7, 8, 10, 17, 18 and 19
> (those that are more MT related than generic input).
> You can also add my 'tested-by' on the whole patch set except for the 20st.

Excellent. Thank you for testing, Benjamin.

Henrik
