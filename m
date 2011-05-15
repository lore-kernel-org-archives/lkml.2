Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1EOJhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 05:37:25 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:63189 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1EOJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 05:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=P5HWH2GvgX2p8wYNz5MNv3eUx1ENqUV39IE5oBAcUxIVzRA2h/1JRWMS2YDSwy0rrF
         u6txo/YemaAoROtIr6zvQM5/QaGnnWgU6cit31hEZQMHlyf6pVxsPMUnTnN80aiCE9KB
         LUsq5eAz/2sbFGn2faYo3c+isQxDYPyyG1roI=
Date: Sun, 15 May 2011 17:37:09 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: anish <anish198519851985@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] preferred form for passing a size to memory
 allocation routines
Message-ID: <20110515093655.GA2768@gmail.com>
Mail-Followup-To: anish <anish198519851985@gmail.com>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <1305395704.7400.17.camel@anish-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1305395704.7400.17.camel@anish-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 11:25:04PM +0530, anish wrote:
> The preferred form for passing a size of a struct is the following:
>          p = kmalloc(sizeof(*p), ...);
> Please refer Documentation/Codingstyle chapter 14
> Signed-off-by: anish kumar<anish198519851985@gmail.com>
> - sfb = kzalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
> + sfb = kzalloc(sizeof(*sfb), GFP_KERNEL);
Hi anish,
	Good catch ;)
Acked-by: Harry Wei <harryxiyou@gmail.com>
