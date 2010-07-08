Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0GHVYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:24:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41220 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0GHVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VwbodSXQnp7qWmZ9oP+G5N2fKZ0CWki6JbWJkfDUJYfeDncrQR5rN8C+M6p78I2227
         v5hCGQ7ZIIx0FCX6MRTGmlBBozaTnNV0ZA6j1bbItZ9zBzf5XwwsSNIUvyfR6WGeXa6+
         gIPKv3+jBk03X3X7eMqUaPmB6LVd3EFP1scEs=
Message-ID: <4C36421B.10305@gmail.com>
Date: Thu, 08 Jul 2010 14:24:43 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: akpm@linux-foundation.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, sftp.mtuci@gmail.com
Subject: Re: [PATCH]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space'
 set but not used
References: <1278616195-3158-1-git-send-email-justinmattock@gmail.com> <4C362FA7.807@acm.org>
In-Reply-To: <4C362FA7.807@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 01:05 PM, Corey Minyard wrote:
> Looks good to me:
>
> Acked-by: Corey Minyard <cminyard@mvista.com>
>

cool Thanks!! just received a post that this has been put into the
mm-tree..

cheers,

Justin P. Mattock
