Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1ADNkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:40:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56231 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1ADNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TUNTvJgP/ua8fLMiwKKbFgoWrShz0u9XkvMCEMvpBteU4mJTjfP0koNRqlDaxheSyA
         NDWcH0nzDxQrvqV813A93hxvnKMsIeUVA1wN33Mwr/swpPMjrKRK32Zk5HRYwMy8veA4
         bj/X6YsxpIkVvxSt3N1c6KWt4io2AkkVf20cM=
Message-ID: <4D232352.2030809@gmail.com>
Date: Tue, 04 Jan 2011 14:40:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58 uploaded]
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
In-Reply-To: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2010 01:58 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to

Hi, this kernel regresses with respect to suspend to ram in comparison
with mmotm 2010-12-16-14-56.

This is OK:
echo devices > /sys/power/pm_test
pm-suspend
This hangs at suspend phase:
echo platform > /sys/power/pm_test
pm-suspend

Note that this kernel is based on next-20101221. Should I try newer (and
clean) -next?

regards,
-- 
js
