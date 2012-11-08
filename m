Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2KHS6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:58:53 -0500
Received: from xes-mad.com ([216.165.139.218]:14386 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2KHS6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:58:51 -0500
Date: Thu, 08 Nov 2012 12:58:36 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers: mfd: Fix resource request for [mem 0x00000000]
Message-ID: <efe3e3f7-eb7f-460b-86d7-293dba8651d8@zimbra>
In-Reply-To: <1352399063.2309.6.camel@thor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> v2: post-decrement to match existing style
>     retitle patch subject
> 
>  drivers/mfd/lpc_ich.c | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Aaron Sierra <asierra@xes-inc.com>

You could make Samuel's job easier by sending a new e-mail
with the latest patch and the correct subject in the e-mail's
subject line. Since this patch doesn't really depend on any of
the other four you submitted, a new message/subject like this
seems appropriate to me:

[PATCH v3] mfd: lpc_ich: Fix resource request for [mem 0x00000000]
