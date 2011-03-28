Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1C1A5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 20:57:01 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17801 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab1C1A5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 20:57:00 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Peter Tyser'" <ptyser@xes-inc.com>
Cc: <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com> <C734E3BF5C7F418896D57EBBD1C709C4@hacdom.okisemi.com> <1301064421.24947.231.camel@petert>
Subject: RE: [PATCH] gpio: ml_ioh_gpio: Fix output value of ioh_gpio_direction_output()
Date: Mon, 28 Mar 2011 09:56:57 +0900
Message-ID: <8C558B2B80654A5EAA6C2E0BDF08E2A0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1301064421.24947.231.camel@petert>
Thread-Index: Acvq+4KppnDPMR2BSou2E3ceJalUoQB5oQ5g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

On Friday, March 25, 2011 11:47 PM, Peter Tyser wrote:
> Out of curiosity, what looks incorrect about the patch?  The 
> code to set the GPIO value is identical to the code in 
> ioh_gpio_set(), which was the old code path.

Sorry, I miss-understood.
Your patch looks good.
In fact, I could confirm the GPIO driver with your patch works well on evaluation board.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

