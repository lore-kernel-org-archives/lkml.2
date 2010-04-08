Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0DHIeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:34:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:40713 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0DHIec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:34:32 -0400
Subject: Re: [PATCH] mtd: Replace the dangerous to_fsl_upm_nand macro with
 an inline function
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <87iq8n0xvj.fsf@tac.ki.iif.hu>
References: <87iq8n0xvj.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 11:32:31 +0300
Message-ID: <1270715551.6754.111.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Apr 2010 08:34:14.0465 (UTC) FILETIME=[45317B10:01CAD6F6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 18:08 +0100, Ferenc Wagner wrote:
> The original macro worked only when applied to variables named 'mtd'.
> While this could have been fixed by simply renaming the macro argument,
> a more type-safe replacement is preferred.
> 
> Signed-off-by: Ferenc Wagner <wferi@niif.hu>

Pushed this and the other similar patch of yours to my l2-mtd-2.6.git /
master, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

