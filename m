Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1BUUjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:39:52 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:38377 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1BUUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:39:51 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 15:39:42 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SYlJVOplpI8GjtvqcNxLM3cLO95DmlCataV7/dhfDVkVsfWux800uOYy20LBxGFnd9
         7p7uvGb1SJvbUVL5HuFzX8wUQsHCAxyFmFKGCzZ+OSqndg8mQRo4doEzd152YykQ/oAK
         KNbrONNdDfbd0d/zqEMa7rOVkeIncJ3nSjHHQ=
Message-ID: <4D62CD93.3040206@gmail.com>
Date: Mon, 21 Feb 2011 21:39:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <4D629427.8020500@gmail.com> <4D629D03.90801@linux.vnet.ibm.com>
In-Reply-To: <4D629D03.90801@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 06:12 PM, Rajiv Andrade wrote:
> On 02/21/2011 01:34 PM, Jiri Slaby wrote:
>> There has to be another problem which caused my regression. And since it
>> reports "Operation Timed out", the former default timeout values worked
>> for me, the ones read from TPM do not.
> Yes, it's highly due inconsistent timeout values reported by the TPM as
> I mentioned, my working timeouts are:
> 3020000 4510000 181000000

1000000 2000 150000

Actually the first one from HW is 1. This is one is HZ after correction
in get_timeout. So perhaps it is in ms, yes.

regards,
-- 
js
