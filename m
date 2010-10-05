Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0JEVMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:12:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab0JEVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xSKbd1S9ksV5LKMPEQWxfbIXH9ii8c3XRxao7qrB1xc6t5Gu1wb25/h4a3d9x4l6RY
         tbWsJfydDgGM3QMlhjK/jXcxTYnzR2l4i1y2VUqljpyTgaD2uMiELIme1cLsx4EqNULA
         0GJ5x6XZoAT5d45rY7cubYrtufTn6u0q6luXA=
Message-ID: <4CAB94A0.8040402@gmail.com>
Date: Tue, 05 Oct 2010 23:12:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/2] HID: hidraw, fix two NULL pointer dereferences
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz> <1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 05:20 PM, Antonio Ospite wrote:
> here are some fixes to hidraw.
> 
> Patches are against 2.6.36-rc6, but they should be ported to other
> maintained stable kernels as well.
> 
> Antonio Ospite (2):
>   HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
>   HID: hidraw, fix a NULL pointer dereference in hidraw_write

Hi, please fix also the window in hidraw_release.

thanks,
-- 
js
