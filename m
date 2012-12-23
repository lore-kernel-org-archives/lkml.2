Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2LWItu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 03:49:50 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3964 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2LWIts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 03:49:48 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1356252567.15507.1.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH] bnx2x: use ARRAY_SIZE where possible
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Sasha Levin" <sasha.levin@oracle.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 23 Dec 2012 10:49:27 +0200
In-Reply-To: <1356030701-16284-16-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-16-git-send-email-sasha.levin@oracle.com>
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CC81B0F39W16866357-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 14:11 -0500, Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Hi Sasha,

I have no problem with this cosmetic change, but it should probably be
sent to net-next when it is open again. When you do resubmit it, you can
add my ACK:

Acked-by Eilon Greenstein <eilong@broadcom.com>

Thanks,
Eilon


