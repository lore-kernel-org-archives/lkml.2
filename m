Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab1DMKcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:32:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab1DMKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zy5rw4OyIxj+j/TD+9TW1yWuNJ1PW/qsFYgyaQOGmfpsBIp+XjogtuBLONEAk43KZl
         5d0Abq65738jl6oWXroKxNbjAN1NctfqILH/DlR3BUeBGLdJYtsJ0wRfH6DksnVTqSC0
         TposWwmRPkUWDqiUtAIoau/0QQnBRRTRObHBM=
Subject: Re: [PATCH v2 1/2] Kconfig: improve KALLSYMS_ALL documentation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
References: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 13:22:52 +0300
Message-ID: <1302690172.2768.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 13:24 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Dumb users like myself are not able to grasp from the existing KALLSYMS_ALL
> documentation that this option is not what they need. Improve the help
> message and make it clearer that KALLSYMS is enough in the majority of
> use cases, and KALLSYMS_ALL should really be used very rarely.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Michal,

what's the fate of these 2 patches? Will you merge them?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

