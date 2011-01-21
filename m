Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1AUUDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:03:46 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58742 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1AUUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:03:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GOmkLG1x1IW7kIPbmkkpZjCEkSwUYuOzdeukq4yiGCiKJNijKcmOEAVZySCR0Jcd/V
         SGK9RlBrekBkUEgJs4I9tgBgCysFa+Gjj86jDx4rUhTHVsBa6HBjzFoW+Sri7+jzX2aF
         38sHS3X6Tq9l5F/KMzUxRYWXwYrVveSMYOrh0=
Message-ID: <4D39E69A.5090107@gmail.com>
Date: Fri, 21 Jan 2011 23:03:38 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alan Ott <alan@signal11.us>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us> <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 06:09 PM, Jiri Kosina wrote:
> There were also efforts to make the report descriptor replaceable in a
> request_firmware() way, but that never converged to state in which it
> could be applied IIRC.
I remember seeing messages about it, but couldn't find it.
Do you have any pointers?
I'm interesting in seeing if it's worth it and maybe finishing it.

Thanks :)

Sincerely,
Nick
