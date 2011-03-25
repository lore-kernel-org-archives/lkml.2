Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab1CYAcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:32:00 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5891 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab1CYAb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:31:59 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Peter Tyser'" <ptyser@xes-inc.com>, <linux-kernel@vger.kernel.org>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
Subject: RE: [PATCH] gpio: ml_ioh_gpio: Fix output value of ioh_gpio_direction_output()
Date: Fri, 25 Mar 2011 09:31:56 +0900
Message-ID: <C734E3BF5C7F418896D57EBBD1C709C4@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
Thread-Index: AcvqeaMwr9S8V8qgR56zfA7EjTsOsQACaWdQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Peter,

On Friday, March 25, 2011 8:17 AM, Peter Tyser wrote:

> The ioh_gpio_direction_output() function was missing a write 
> to set the desired output value.  The function would properly 
> set the GPIO direction, but not the output value.  The value 
> would have to manually be set with a follow up call to ioh_gpio_set().

> This is untested - just noticed it while working on an 
> unrelated change.  An ack or tested-by from someone with real 
> hardware would be appreciated.

Thank you for your indication.
Your saying is right.
However since your patch looks incorrect,
after testing, I will post new patch by next week.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


