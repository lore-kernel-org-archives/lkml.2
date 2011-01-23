Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1AWDd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 22:33:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58904 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1AWDdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 22:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hdX3epQEg6FYe89VkUCg0JtUsTrAGYIzXWEjzHY15BTHXeNMdYZ7nJGRIfEraAc/Rs
         4Blp6V/1VFo2tomA6eKvIvnjb/MNuUr3xM3frvpPG80sj+rMKtZuPFvlmKoBUjejJdo/
         Y+q3TOF48T4wrzwrJ60ewrnbv+rIwAqI4Mwi0=
MIME-Version: 1.0
In-Reply-To: <4d3b4ac1.26092a0a.6f30.ffffcf6b@mx.google.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <1295648870.23779.15.camel@marge.simson.net>
 <4d3b4ac1.26092a0a.6f30.ffffcf6b@mx.google.com>
From: Michael Witten <mfwitten@gmail.com>
Date: Sat, 22 Jan 2011 21:32:54 -0600
Message-ID: <AANLkTinU7kFRSkNZ2JcyGYPWRF9LP48FqWZknVafm56a@mail.gmail.com>
Subject: Re: 'autogroup' sched code KILLING responsiveness
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 15:23, Michael Witten <mfwitten@gmail.com> wrote:
> Of course, I have none of these problems when I disable:
>
>  CONFIG_AUTOGROUP_SCHED

Of course, if CONFIG_AUTOGROUP_SCHED is enabled, then the problem also
goes away if the kernel is booted using the `noautogroup' parameter.
