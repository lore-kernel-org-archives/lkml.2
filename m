Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2JBEOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:14:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44159 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JBEOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:14:48 -0400
Message-ID: <506A6A35.4060500@kernel.org>
Date: Tue, 02 Oct 2012 00:14:45 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Ortiz, Lance E" <lance.oritz@hp.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Add new sysfs interface to export device description
References: <1347035296-8882-1-git-send-email-lance.ortiz@hp.com> <50595BF0.2010002@jp.fujitsu.com> <A961433CDFF2F640A2866803152E61F950D1B50A@G9W0753.americas.hpqcorp.net>
In-Reply-To: <A961433CDFF2F640A2866803152E61F950D1B50A@G9W0753.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> To address your comment, I was trying to differentiate between the existence of the _STR method and the failure to evaluate it.
> If an STR method exists, we create the sysfs file.  If it fails to
evaluate, we will see "No Description" when we read the file.
> This would indicate that something is wrong as opposed to the system not having an _STR.
> If you feel that this is unnecessary, or should be done differently let me know.

This patch looks useful, and I this does seem like a logical place
to export this information.

however, I'd think that an empty attribute instead of "No description"
is sufficient to cover the case of _STR existing, but for some reason
failing to evaluate.

thanks,
Len Brown, Intel Open Source Technology Center

