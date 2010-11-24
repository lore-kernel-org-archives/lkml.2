Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab0KXFAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:00:13 -0500
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:44690 "HELO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750707Ab0KXFAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:00:12 -0500
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201011231256.oANCur3N016433@amcc.com> <201011231421.02377.sr@denx.de>
In-Reply-To: <201011231421.02377.sr@denx.de>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuLEU84SJoTid62Q+q5FewNjXp/vAAgilPw
Date: Wed, 24 Nov 2010 10:25:03 +0530
Message-ID: <602c780cd2a81ee32f834a82814fe77f@mail.gmail.com>
Subject: RE: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
To: Stefan Roese <sr@denx.de>, linuxppc-dev@lists.ozlabs.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> +#define BCSR_USB_EN	0x11
>This define is wrong here. Its not common for all 44x platforms but
Canyonlands specific.

So, do you suggest to move this macro to the canyonlands.c ? Or introduce
canyonlands.h ?

Regards,
Rup
