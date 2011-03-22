Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1CVNn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:43:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:27435 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751361Ab1CVNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:43:26 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: y7.Kid8VM1kSgSOcNdv9ws3YwoKU.BYk.KSfR_A2KTHehRZ
 9h.7XrlaVUzr2kIMMXYCaYSoRF5B_6_5YggmbqOGqDwTVX1YHbWi8CHskAFb
 D3SlvXxvwjVshRcntlligaaa5hQ7EwrsVuWo26vrWazZNUSFT5AZBt2Uoxy0
 jOeLO3FwhAoQWBUi3v9ehbuXPYL4T49L43A.ZbwJvYc1XTfjQED12.x8vJp9
 cRYhlOoo7nlVUIbUz0GgVNwrBFjoZQtPzmQsbxvVq1eas6tt3pbTpYCiwQtD
 MId6YuVYhJdR7glkePsro00DjkZfK.nHyOEmMkDZQ6kP02cnEHpu3
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Mar 2011 08:43:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused zone_idx variable from
 set_migratetype_isolate
In-Reply-To: <20110322112647.GA5086@swordfish.minsk.epam.com>
Message-ID: <alpine.DEB.2.00.1103220843040.14318@router.home>
References: <20110322112647.GA5086@swordfish.minsk.epam.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 22 Mar 2011, Sergey Senozhatsky wrote:

> mm: remove unused variable zone_idx and zone_idx call from set_migratetype_isolate
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Reviewed-by: Christoph Lameter <cl@linux.com>

