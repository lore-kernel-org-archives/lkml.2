Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1FMXgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:36:36 -0400
Received: from mail.perches.com ([173.55.12.10]:2896 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1FMXgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:36:35 -0400
Subject: RE: two false alarms from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Jian Peng <jipeng@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874572DE7E973@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874572DE7E95F@IRVEXCHCCR01.corp.ad.broadcom.com>
	 <1308007436.26699.57.camel@Joe-Laptop>
	 <E18F441196CA634DB8E1F1C56A50A874572DE7E973@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 16:36:33 -0700
Message-ID: <1308008193.26699.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 16:28 -0700, Jian Peng wrote:
> On the other hand, 
> while (1); 
> is a style that was used universally by C programmers. Could you rethink about take this as exception in checkpatch.pl?

For some subset of C programmers... ;)

The kernel generally uses "unreachable()" instead.


