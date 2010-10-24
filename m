Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab0JXWYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:24:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49987 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab0JXWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wuHjNw8PyuUryt6pxwboOvV7LlFOvhPap57iXJCQTHYKmDdO32csnG+9itFOM45dzm
         ErnKSTZJs8VlaTLVMSj756jwN5KGvwwTUjM+Dvuknn1d4ynaACOkYONgrk+kj/GCIP2T
         CxSoUWZ6QtLPZD60j1M3tIC4QuZTB+1gXDpbw=
Message-ID: <4CC4B210.2010608@lwfinger.net>
Date: Sun, 24 Oct 2010 17:24:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Luciano Coelho <luciano.coelho@nokia.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/wl1271: remove redundant if-statement
References: <20101025000744.17f7086e@absol.kitzblitz>
In-Reply-To: <20101025000744.17f7086e@absol.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 05:07 PM, Nicolas Kaiser wrote:
> Apparently the return value of wl1271_ps_elp_sleep never gets
> checked anyway.

The patch is fine, but this comment is a little misleading as
wl1271_ps_elp_sleep() is void and cannot return a value.

Larry
