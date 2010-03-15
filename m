Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936653Ab0COUAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:00:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44988 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936605Ab0COUAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:00:02 -0400
Message-ID: <4B9E91BC.7010208@zytor.com>
Date: Mon, 15 Mar 2010 12:59:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Wang, Shane" <shane.wang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [PATCH v2] intel_txt: fix section warning messages from tboot
 when "allyesconfig" is set on i386
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C6817@shsmsx501.ccr.corp.intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690F@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A1D3C690F@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shane,

All your patches are sent in a form which is difficult for automation.
Could you please use "git send-email" instead of whatever method you are
currently using to send patches?

	-hpa

