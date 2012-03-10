Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2CJLJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 06:09:04 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59296 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2CJLJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 06:09:02 -0500
Message-ID: <4F5B364A.5000209@gmail.com>
Date: Sat, 10 Mar 2012 13:08:58 +0200
From: Rares Aioanei <krnl.list@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Git pull on linux-next tree shows "Performing inexact rename
 detection"
References: <4F5A4BE7.60308@gmail.com>
In-Reply-To: <4F5A4BE7.60308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 08:28 PM, Prasanna Kumar T S M wrote:
> Doing "git pull" on linux-next tree always shows "Performing inexact
> rename detection" for a very long time (more than a hour and going). It
> also uses more than 1.5GB of RAM (out of 2GB RAM) in my system. Not able
> to do any thing when this is happening - even maximising a window takes
> 2 minutes once such a situation is reached. I am killing the command
> with a Ctrl + C as I am not able to do any work.
>
> What is the reason for this? What it does internally? Is there any way
> to circumvent this? I don't want to clone linux-next again (that seems
> to be the worst case solution).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
The first Google search result gave me this: 
http://git.661346.n2.nabble.com/Merging-limitations-after-directory-renames-interesting-test-repo-td6041103.html

While long and pretty technical, it will shed some light, I believe. 
Good luck.

-- 
--
Rares Aioanei

