Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0FLL4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 07:56:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20740 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0FLL4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 07:56:03 -0400
Subject: Re: [PATCH 4/8] fs/ubifs: Use ERR_CAST
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005221200050.13021@ask.diku.dk>
References: <Pine.LNX.4.64.1005221200050.13021@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 14:53:28 +0300
Message-ID: <1276343608.19028.118.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Jun 2010 11:55:47.0224 (UTC) FILETIME=[31E3D180:01CB0A26]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 12:00 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
> clear what is the purpose of the operation, which otherwise looks like a
> no-op.

Pushed to the ubifs-2.6.git tree, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

