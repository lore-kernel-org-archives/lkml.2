Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0DWToj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:44:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33820 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0DWToe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:44:34 -0400
From: <Kai.Vehmanen@nokia.com>
To: <paul@pwsan.com>, <Carlos.Chinea@nokia.com>
CC: <linux-kernel@vger.kernel.org>, <s-jan@ti.com>,
       <linux-omap@vger.kernel.org>
Date: Fri, 23 Apr 2010 21:44:16 +0200
Subject: RE: [RFC PATCH 0/5] HSI framework and drivers
Thread-Topic: [RFC PATCH 0/5] HSI framework and drivers
Thread-Index: Acri/oGPz3dxWSusRdSZb3qfaMVAAwAG1/8g
Message-ID: <725063E4C37388418CDDC5A2C287906A16B778D24E@NOK-EUMSG-03.mgdnok.nokia.com>
References: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
 <alpine.DEB.2.00.1004231001190.29720@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1004231001190.29720@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Apr 2010 19:44:18.0928 (UTC) FILETIME=[5D1DEF00:01CAE31D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul and others,

On 23 April 2010, Paul Walmsley wrote:
>> SSI, which is a legacy version of HSI, is used to connect the application
>> engine with the cellular modem on the Nokia N900.
>>
>> This patch set is based on 2.6.34-rc3
>
>Have you looked at Sébastien's HSI driver code:
>
>http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18506.html

I think the history of the patches is already shared. I've been 
looking at this from the sidelines and I think the story so 
far is:

2008: Carlos sent the original SSI patchset (and got comments)
   -> http://lkml.org/lkml/2008/10/3/116
2009: Sébastien sent an updated patchset (and got comments)
   -> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18506.html

.. and now this latest one from Carlos is a completely new
design that attempts to address the design comments that have
been raised, hopefully pushing HSI/SSI a step closer to 
getting accepted. I'll leave it to Carlos and Sébastien to 
correct me if I got the above wrong...

Br,
-- 
Kai Vehmanen

