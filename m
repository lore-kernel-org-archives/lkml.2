Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0LWKD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:03:58 -0500
Received: from r-mail2.rd.francetelecom.com ([217.108.152.42]:30822 "EHLO
	r-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373Ab0LWKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:03:57 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 05:03:57 EST
Message-ID: <4D131C9A.4020503@Free.fr>
Date: Thu, 23 Dec 2010 10:55:38 +0100
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101213 Lightning/1.0b2 Icedove/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.37-rc7: no more shutdown on DELL E6400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2010 09:55:38.0623 (UTC) FILETIME=[8D5E18F0:01CBA287]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the following messages:

Will now halt
hub:4-0:1.0: hub_port_status_failed (err 110)

repeated twice.

I did not attend the shutdown last evening and it was blocked there this 
morning. Retested and found same error.

Will open a regression bug (never have got this since 2.6.33).

-- eric

