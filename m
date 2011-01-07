Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1AGAVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:21:46 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34728 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab1AGAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:21:45 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: "'Randy Dunlap'" <randy.dunlap@oracle.com>
References: <20110106215404.GA30624@kroah.com> <1294352605-31906-22-git-send-email-gregkh@suse.de>
Subject: RE: [PATCH 22/36] serial: fix pch_uart kconfig & build
Date: Fri, 7 Jan 2011 09:21:43 +0900
Message-ID: <8899E5C010CA4DECA82313385205780B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acut8GZIKI7L3DhOSzeAOg5GmEcrjgADgfAA
In-Reply-To: <1294352605-31906-22-git-send-email-gregkh@suse.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Friday, January 07, 2011 7:23 AM, Greg Kroah-Hartman wrote:
> Also, the help text says that the 
> driver enables & uses PCH_DMA, which is not enabled, so select that. 

I think PCH_DMA is not always used when a user uses PCH_UART.
Since overhead of DMA is not small, in case of low frequent communication,
without DMA is better.
Thus, I think "select PCH_DMA" is unnecessary

(Of course, the PCH_UART works both with/without PCH_DMA.)

-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

