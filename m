Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0KZPcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:32:41 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:46037 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751075Ab0KZPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:32:40 -0500
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201011261110.oAQBANZL012455@amcc.com> <20101126142342.E05A411D94F1@gemini.denx.de>
In-Reply-To: <20101126142342.E05A411D94F1@gemini.denx.de>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuNdYtswZ5ut3UmTJSe9I08TEtBGgACKTdQ
Date: Fri, 26 Nov 2010 21:02:36 +0530
Message-ID: <ade8814261339ab5028557ae3dc15c0b@mail.gmail.com>
Subject: RE: [PATCH v3] ppc44x:PHY fixup for USB on canyonlands board
To: Wolfgang Denk <wd@denx.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

>> This results in a mix of "amcc," and "apm," strings.
>> Are there any plans to unify this?
We can make all as apm, but right now I believe there is no plan to do so.

>>Earlier versions of the patch included a delay after the clrbits8()
>>call as well. Is it intentional that you dropped this now?
It is dropped intentionally.

Rest of your suggestions, I will modify and resubmit. Thanks.

Regards,
Rup
