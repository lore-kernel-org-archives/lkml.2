Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0LMGGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:06:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0LMGG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=LIAPT/3JJUmTGZrc0ZaUDh/kYia/8rv7gBmpFaYi0z06BI1QeshU5mg8ABtioWo17F
         Y4CAClAQh4lRqregaDGXgjbOusYAJnbJHqyNCim2wBild4qCxuHY8N75plEqqqxuiKRs
         cFO4wzAXKje0cg5BLzqHf9E/tydGHO2LuXxmc=
Date: Mon, 13 Dec 2010 09:05:03 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/3] Staging: rt2860: Clean spaces before tabs
Message-ID: <20101213060503.GB1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	=?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
 <1292176591-26081-2-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292176591-26081-2-git-send-email-agimenez@sysvalve.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 06:56:29PM +0100, L. Alberto Giménez wrote:
>  #define RT_QUERY_SIGNAL_CONTEXT				0x0402
> -#define RT_SET_IAPP_PID                 	0x0404
> +#define RT_SET_IAPP_PID				0x0404
>  #define RT_SET_APD_PID						0x0405
>  #define RT_SET_DEL_MAC_ENTRY				0x0406
>  #define RT_QUERY_EVENT_TABLE			0x0407

Haha.

Those constants are supposed to be in a line instead of all just 
higgledy-piggledy.  Please can you fix this properly.

regards,
dan carpenter
