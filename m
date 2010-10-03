Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0JCRB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:01:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62796 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0JCRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=C89/aSThv54My1blSEH2nRPmn7akaeleXCixFjZA4NvJpciWO5nTPRUjAEkXs9Rq+j
         qbmfg8d4v/akOIJpyjVAa2hhVPrhb3ovYeCid/GN91GSyktgEc/uLwvs6C4s9wCENPEm
         3y7jtKc/poxbKXBlBk6fcwDYf4+02oWQbQIoU=
Message-ID: <4CA8B6E4.2060109@gmail.com>
Date: Sun, 03 Oct 2010 19:01:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frank Coldwell <junkdnaseq@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: gcc compile kernel 2.6 module
References: <AANLkTi=fH924fybfmSpxyOu5Vm8Ny9cSyMGWcQN3dvvD@mail.gmail.com>
In-Reply-To: <AANLkTi=fH924fybfmSpxyOu5Vm8Ny9cSyMGWcQN3dvvD@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2010 01:31 PM, Frank Coldwell wrote:
> Does anybody know how should look gcc compilation line
> to compile kernel module for kernel 2.6

Don't do this on your own, leave it on kbuild:
Documentation/kbuild/modules.txt

regards,
-- 
js
