Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0H3VdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:33:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50934 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0H3VdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wck03Ct2DF7/8R4ZsNjoe1D4FnfKG1DsefIICYk8GjsmguvdcweSlMKZ4mfUjMF//j
         /3CMbaEG9RpMjTr2OZF3AmvTWB7TT2G2x9bR/QNvqY+3Oa8xhK1f1cdXmLbYbk+p1HF/
         OP2B2LRJ6/ydDoZHsQ/VqP+vZOmXGKVaoOh2s=
Message-ID: <4C7C238D.2070505@gmail.com>
Date: Mon, 30 Aug 2010 23:33:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36
 changes
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com> <1282959209-5431-3-git-send-email-john.johansen@canonical.com> <4C794310.1020801@canonical.com> <4C795242.80402@gmail.com> <4C797315.7030204@canonical.com> <4C797627.6080708@gmail.com> <4C7BE205.40202@canonical.com>
In-Reply-To: <4C7BE205.40202@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 06:53 PM, John Johansen wrote:
> /* TODO: extend resource control to handle other (non current) processes.
>  * AppArmor rules currently have the implicit assumption that the task
>  * is setting the resource of the current process
>  */

Makes sense(TM) now.

thanks,
-- 
js
