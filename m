Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0GUH5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:57:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44619 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab0GUH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pk12s0frWWVlbqQlrmhnFFMDAuxvBTFkyU8GyM531E7nrAVr7j0U7fCGk0HHoOjrQQ
         Pwkx0OHFgCy70xxjUYN4KKvFNCT6nvATT4rk1WXXWdqF8Y1RYskwudTIEoYvxmbKdqkX
         t8Q7ll+aMWelutk54gv4TDfR+j0LtGvv7MKXQ=
Message-ID: <4C46A85C.2090608@gmail.com>
Date: Wed, 21 Jul 2010 09:57:16 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        ss@aao.gov.au, gregkh@suse.de
Subject: Re: [PATCH] Staging: dt3155: Remove copy_to_user for ioctl's DT3155_{STOP|START}
References: <201007201757.52928.hartleys@visionengravers.com>
In-Reply-To: <201007201757.52928.hartleys@visionengravers.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 02:57 AM, H Hartley Sweeten wrote:
> The ioctl's DT3155_STOP and DT3155_START are defined with the macro
> _IO indicating that they have no parameters. They should not be using
> copy_to_user to return data to user space.

This is not a reason for removing them. You should check what real users
do/expect and base your reasoning on the top of that.

So could you investigate that?

regards,
-- 
js
