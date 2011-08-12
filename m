Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab1HLU1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:27:54 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:52876 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab1HLU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:27:53 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=wSWQpAr6UJYA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=J1mbgZyY04IlwC6AL_EA:9 a=CjuIK1q_8ugA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com> <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se>
In-Reply-To: <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se>
Subject: RE: [patch v5 resending 0/8] Add slicing-by-8 to crc32
Date: Fri, 12 Aug 2011 15:27:50 -0500
Message-ID: <02c501cc592e$4f5f6000$ee1e2000$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQB1TE/iCpDUaKMDJaAWrgI6YSoYCwKURzh8l7MgHkA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am not even going to try. After a quick look they still look broken

You are right, of course ;-) Patches 2, 6 and 7 each had one line in the
original with trailing whitespace.
Something in the process I used stripped the whitespace from the patch. I
will make another attempt and check them first. I miss the old days when I
could cat a file to sendmail. Thunderbird is hell and outlook which I am
required to use for most things is worse.

Thank you for your patience.

Bob

