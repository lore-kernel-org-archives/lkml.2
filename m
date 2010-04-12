Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0DLNaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:30:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:25239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0DLN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QS9xIfwPZqYzEDd6sBFsMug1ZUhRKBRNdngovtsIys11SOyEWhyIXF+EWTSWzmRvCL
         uitOQ/ga3glp4Hu5DjY9Gy9D1HkvOag23MByKGILrvTtOD4vuHavZz+Wjjxsfk7YJTD6
         fe5kBOiPP4HQuYmWju3UDL7+jE2J3tc+BRuAc=
Message-ID: <4BC32050.7080806@boichat.ch>
Date: Mon, 12 Apr 2010 21:29:52 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100313 Thunderbird/3.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Switch applesmc maintainer
References: <1271078868-3699-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1271078868-3699-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 09:27 PM, Henrik Rydberg wrote:
> Nicolas has expressed a wish to be relieved from the maintenance
> of applesmc, so we simply switch maintainer with this patch.

Thank you.

> Signed-off-by: Henrik Rydberg<rydberg@euromail.se>

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>

> ---
>   MAINTAINERS |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a9ccda..13c5688 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -485,8 +485,8 @@ S:	Maintained
>   F:	drivers/input/mouse/bcm5974.c
>
>   APPLE SMC DRIVER
> -M:	Nicolas Boichat<nicolas@boichat.ch>
> -L:	mactel-linux-devel@lists.sourceforge.net
> +M:	Henrik Rydberg<rydberg@euromail.se>
> +L:	lm-sensors@lm-sensors.org
>   S:	Maintained
>   F:	drivers/hwmon/applesmc.c
>

