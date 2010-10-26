Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0JZLqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:46:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab0JZLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G+/VBikDv2vWllk42nbknSjqzfgGtfXZJhcV1JOgeSGZHHGJiLR1YnuWHu1/8+oKOQ
         U3hS/A1yy/Z8CyW9gHvgcdUIyfRPAql/4Y/5WImUYbRossKqSXV8T86g2FBymFbb1MHY
         p1e8Bgv1s76VnnnLyic0bFDwLBgFlwptK+Ljs=
MIME-Version: 1.0
In-Reply-To: <1288054306-4361-2-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
Date: Tue, 26 Oct 2010 14:46:14 +0300
Message-ID: <AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com>
Subject: Re: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: gregkh@suse.de, felipe.contreras@nokia.com, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> The device address is assigned by tidspbridge no need for that parameter anymore.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>

This would break the API with user-space, right?

I think this change should be delayed, preferably after we have a
working tidspbridge.

-- 
Felipe Contreras
