Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1CVOLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:11:08 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:57042 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab1CVOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:11:03 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv: update dist release parsing in hv_kvp_daemon
Thread-Topic: [PATCH] hv: update dist release parsing in hv_kvp_daemon
Thread-Index: AQHL6G/gOvO5LnCwTkeVjza0fMLjyJQ5ZOeg
Date: Tue, 22 Mar 2011 14:11:01 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048021372@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <20110322090217.GA1678@aepfle.de>
In-Reply-To: <20110322090217.GA1678@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2MEBEFa006855



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 22, 2011 5:02 AM
> To: Hank Janssen; Haiyang Zhang; Greg Kroah-Hartman; KY Srinivasan
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] hv: update dist release parsing in hv_kvp_daemon
> 
> The current code to parse the distribution file handles only files with
> at least 3 lines. openSuSE has 2 lines and Redhat only one (according to
> google).
> Update the parser to handle up to three lines properly. Also make the
> buffer allocation dynamic and remove a few casts to avoid compiler
> warnings.

Looks good. Thanks Olaf.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
