Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab0HFD6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:58:06 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:35198 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab0HFD6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:58:04 -0400
X-Greylist: delayed 1931 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 23:58:04 EDT
Message-ID: <4C5B80DB.5050204@xenontk.org>
Date: Fri, 06 Aug 2010 08:56:19 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.11) Gecko/20100720 Thunderbird/3.0.6
MIME-Version: 1.0
To: Shuang He <shuang.he@intel.com>
CC: Thomas Meyer <thomas@m3y3r.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Zou, Nanhai" <nanhai.zou@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
References: <201008011101.01429.thomas@m3y3r.de>	<4C555DA0.6020109@s5r6.in-berlin.de> <98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de> <4C5A4F68.5030309@intel.com>
In-Reply-To: <4C5A4F68.5030309@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 11:13 AM, Shuang He wrote:

> Could you help report a bug for this issue by following
> http://intellinuxgraphics.org/how_to_report_bug.html
> 

I have the same issue on a GM45 and Thomas's hack works in fixing it. It
is still present in 2.6.35.

Regards,
David.
