Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab0EELTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:19:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17733 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0EELTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:19:41 -0400
Subject: Re: [PATCH] mtd: Increase NAND_MAX_OOBSIZE from 128 to 256
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <e511d9573281d8376f800574fac2d72663e2d558@localhost.localdomain>
References: <e511d9573281d8376f800574fac2d72663e2d558@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 14:19:05 +0300
Message-ID: <1273058345.3702.175.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 11:19:27.0033 (UTC) FILETIME=[D2B29290:01CAEC44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 21:20 -0700, Kevin Cernekee wrote:
> NAND_MAX_OOBSIZE needs to be increased to support newer parts with
> 218 or 224 byte spare areas.  Tested with Samsung K9GAG08U0D.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Pushed to l2-mtd-2.6 / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

