Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GSKZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:25:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52277 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab1GSKZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:25:22 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, "'Jon Povey'" <Jon.Povey@racelogic.co.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 15:54:53 +0530
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Topic: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Index: AcxFxEO6UigcFyPiSea2qTqvKwuHFAAD90YgAAItJbAAAYrhkAADtLFAAAMRbOo=
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BBC5CEC@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73E@dbde02.ent.ti.com>
 <70E876B0EA86DD4BAF101844BC814DFE0B4E0859D7@Cloud.RL.local>
 <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73F@dbde02.ent.ti.com>,<B85A65D85D7EB246BE421B3FB0FBB593024DBDC695@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024DBDC695@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure. Please do.

Thanks and Regards,
-Manju
________________________________________
From: Nori, Sekhar
Sent: Tuesday, July 19, 2011 2:30 PM
To: Hadli, Manjunath; 'Jon Povey'; davinci-linux-open-source@linux.davincidsp.com; linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits

Hi Manju,

On Tue, Jul 19, 2011 at 12:55:13, Hadli, Manjunath wrote:
> Will not be able to give you a sub-patch as it is combined as part of a larger implementation.
>
> Since the bug fix needs to go into 3.0, I am Ok if you fix the bug, and the
> macros can be substituted later.

I am going to take this as your ack and add:

Acked-by: Manjunath Hadli <manjunath.hadli@ti.com>

while committing.

Thanks,
Sekhar

