Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2GaX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:27:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41281 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2GaX1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:27:50 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-25-501869f517a3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Sean Paul'" <seanpaul@chromium.org>,
        "'Sangsu Park'" <sangsu4u.park@samsung.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        dianders@chromium.org
References: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
 <CACRpkdZupvxyadxi8GppP6W2Pe5-eOcdjYYAcS28euUk8vx9iQ@mail.gmail.com>
In-reply-to: <CACRpkdZupvxyadxi8GppP6W2Pe5-eOcdjYYAcS28euUk8vx9iQ@mail.gmail.com>
Subject: RE: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
Date: Wed, 01 Aug 2012 08:27:45 +0900
Message-id: <02cd01cd6f74$1924e430$4b6eac90$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1sTOF9F1tC+4UJTACa+0uiA0vifwDJwYog
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd2vmRIBBleXy1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MyzOmMBesYqtY2L+HrYHxH0sXIyeHhICJRM/ma1C2mMSFe+vZ
	uhi5OIQEFjFKXPx7kBXCmcckcXPWDnaQKjYBDYnD75+xgyREBBoYJeZseQhWxSzQxihx/m4j
	I0RLN6PE97mHwAZzCgRLHP+9FcwWFvCQOHX5NCuIzSKgKjH7ykawOK+ArcTELUvZIGxBiR+T
	74HFmQW0JNbvPM4EYctLbF7zlrmLkQPoWHWJR391QcIiAkYSu480QZWISOx78Y5xAqPQLCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7nZ9I7GFc1WBxiFOBg
	VOLhfWEmESDEmlhWXJl7iFGCg1lJhFctAijEm5JYWZValB9fVJqTWnyIUZqDRUmc18T7q7+Q
	QHpiSWp2ampBahFMlomDU6qB0SPi+9LrGjuNLfRF/jvzzpzmfvR7oOtRMY8YrqDfvZdmdmjw
	m5T39O/26NVwEWDK49K7p6t/+Fl249TkHzIJjeqTspZyWnicX/wg76/9FvdLC1QMGReffjpz
	6/y9Md3aU85uuTRZY5pEY71UcNJmoy/3i/IdYx8dva/K5ML78q/jg1faRm0TlFiKMxINtZiL
	ihMB3XXB22MCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Fri, Jul 20, 2012 at 10:58 PM, Sean Paul <seanpaul@chromium.org> wrote:
> 
> > Move gpc4 to the end of the automatically processed gpio controllers so
> > we don't taint the automatic offset calculation.
> >
> > This bug caused all controllers coming after gpc4 to map to the
> > incorrect address. The result is <&gpd1 0 0 0 0> would actually map to
> > GPIO 0 in gpd0.
> >
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> 
> Samsung people, please comment on this patch.
> 
Looks good to me, please keep going on.
And feel free to add my ack on this.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

