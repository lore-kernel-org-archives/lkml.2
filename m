Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2BFIh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:37:56 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43535 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2BFIhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:37:54 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiVTACuRL09V5qrvPGdsb2JhbABDiVKlZhkBAQEBNzKBcgEBBAEnExwTAQ8FCwgDRhQlChoTh3wDuQMTi1cCAgkFDAcGAQQBAQkEFAcEDwMDAYJ1AgsDBBoEAoEXCgSCTGMElSeFaIx1
X-IronPort-AV: E=Sophos;i="4.73,369,1325458800"; 
   d="scan'208";a="1804103761"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 6 Feb 2012 09:39:09 +0100
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 0/3] Support of Perixx Peripad 701 for hid-multitouch
Message-ID: <20120206083909.GA3972@polaris.bitmath.org>
References: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This is the v3 of the support of Perixx Peripad 701.
> 
> I included the changes asked by Henrik & Dmitry:
> -           code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;
> +           code =  BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);
> use of min;
> remove remove the call to input_mt_report_finger_count;
> remove debug information;
> some cosmetic changes (parenthesis, typos)

Looking good now, thanks.

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Henrik
